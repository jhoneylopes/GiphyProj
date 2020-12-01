import RxSwift
import RxCocoa

public protocol AppStateProtocol {
    var favorites: BehaviorRelay<[GIFModelDTO]> { get set }
    var source: BehaviorRelay<SearchResult<GIFModelDTO>> { get set }
}

public struct AppState: AppStateProtocol {
    public static var shared = AppState()
    public var favorites: BehaviorRelay<[GIFModelDTO]> = BehaviorRelay(value: [])
    public var source: BehaviorRelay<SearchResult<GIFModelDTO>> = BehaviorRelay(value: SearchResult<GIFModelDTO>(data: []))
    private init() { }
}
