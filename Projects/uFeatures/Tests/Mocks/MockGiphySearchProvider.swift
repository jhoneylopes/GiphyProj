import RxSwift
@testable import uCore

final class MockGiphySearchProvider: GiphySearchProviderProtocol {
    var didCallMock: Bool = false

    func fetch(_ search: String?, _ offset: Int?) -> Observable<SearchResult<GIFModelDTO>> {
        didCallMock = true
        return Observable.empty()
    }
}
