import Foundation
import RxSwift

public protocol GiphySearchProviderProtocol {
    func fetch(_ search: String?, _ offset: Int?) -> Observable<SearchResult<GIFModelDTO>>
}

public class GiphySearchProvider: GiphySearchProviderProtocol {
    private let disposeBag = DisposeBag()
    private let baseProvider = DependencyManager.resolve(BaseProvider.self)

    public init() {}

    public func fetch(_ search: String?, _ offset: Int?) -> Observable<SearchResult<GIFModelDTO>> {
        baseProvider.fetch(search, offset)
            .flatMap { response -> Observable<SearchResult<GIFModelDTO>> in
                if case let .success(data) = response {                    
                    AppState.shared.source.accept(data)                    
                    return .just(data)
                }
                return .empty()
        }
    }
}

extension CoreAPIService: BaseProvider {
    public func fetch(
        _ search: String?, _ offset: Int?
    ) -> Observable<Result<SearchResult<GIFModelDTO>, ProviderError>> {
        var query: [URLQueryItem] = [URLQueryItem(name: "rating", value: "g")]

        if let search = search, let offset = offset {
            query.append(URLQueryItem(name: "q", value: search))
            query.append(URLQueryItem(name: "limit", value: "\((offset + 1)*10)"))
            query.append(URLQueryItem(name: "offset", value: "0"))
        } else {
            query.append(URLQueryItem(name: "limit", value: "10"))
        }

        let path = search?.isEmpty ?? true ? Endpoint.trending.rawValue : Endpoint.search.rawValue

        let request = makeRequest(
            path: path,
            httpMethod: HTTPMethod.get.name,
            query: query
        )

        return perform(request: request)
    }
}
