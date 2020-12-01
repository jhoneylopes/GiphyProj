import RxSwift

public protocol BaseProvider {
    func fetch(_ search: String?, _ offset: Int?) -> Observable<Result<SearchResult<GIFModelDTO>, ProviderError>>
}

public protocol BaseDatabaseProvider {
    func save(data: [GIFModelDTO]) -> Bool
    func fetchData() -> [GIFModelDTO]
}
