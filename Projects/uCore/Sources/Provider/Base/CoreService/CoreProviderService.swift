import Foundation
import RxSwift
import Keys

public class CoreAPIService {
    let baseURL: URL

    public init(baseURL: URL = URL(string: "https://api.giphy.com")!) {
        self.baseURL = baseURL
    }

    func perform<T: Decodable>(request: URLRequest) -> Observable<Result<T, ProviderError>> {
        return Observable<Result<T, ProviderError>>.create { observer in
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    let apiError = ProviderError.network(error)
                    let result: Result<T, ProviderError> = .failure(apiError)
                    observer.onNext(result)
                }
                guard let data = data else {
                    let apiError = ProviderError.noData(response)
                    let result: Result<T, ProviderError> = .failure(apiError)
                    observer.onNext(result)
                    return
                }

                let validStatusCodes = 200..<300

                guard let httpResponse = response as? HTTPURLResponse, validStatusCodes.contains(httpResponse.statusCode) else {
                    let apiError = ProviderError.server(response)
                    let result: Result<T, ProviderError> = .failure(apiError)
                    observer.onNext(result)
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    let value = try decoder.decode(T.self, from: data)
                    let result: Result<T, ProviderError> = .success(value)
                    observer.onNext(result)
                } catch {
                    let apiError = ProviderError.decoding(error)
                    let result: Result<T, ProviderError> = .failure(apiError)
                    observer.onNext(result)
                }
                observer.onCompleted()
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
    }

    func makeRequest(path: String, httpMethod: String, query: [URLQueryItem] = []) -> URLRequest {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        urlComponents.path = path

        let keys: GiphyProjKeys = GiphyProjKeys()

        let apiKey = keys.giphyAppKey
        var queryItems = query
        queryItems.append(URLQueryItem(name: "api_key", value: apiKey))

        urlComponents.queryItems = queryItems

        let url = urlComponents.url!

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
