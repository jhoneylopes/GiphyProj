import RxSwift
import RxCocoa
@testable import uCore

struct UnitAppState: AppStateProtocol {
    public static var shared = UnitAppState()
    public var favorites: BehaviorRelay<[GIFModelDTO]> = BehaviorRelay(value: UnitAppStateFactory.makeFavorites())
    public var source: BehaviorRelay<SearchResult<GIFModelDTO>> = BehaviorRelay(value: UnitAppStateFactory.makeSource())
    private init() { }
}

struct UnitAppStateFactory {
    static func makeFavorites() -> [GIFModelDTO] {
        return [GIFModelDTO(id: "id1", images: nil),
                GIFModelDTO(id: "id2", images: nil),
                GIFModelDTO(id: "id3", images: nil),
                GIFModelDTO(id: "id4", images: nil)]
    }

    static func makeSource() -> SearchResult<GIFModelDTO> {
        return SearchResult<GIFModelDTO>(data: makeFavorites(), pagination: nil, meta: nil)
    }
}
