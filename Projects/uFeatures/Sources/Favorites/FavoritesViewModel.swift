import uCore
import RxSwift
import RxCocoa
import RxDataSources

final class FavoritesViewModel: ViewModel {
    var transform: (Input) -> Output

    struct Input {
        let appStateFavorites: Observable<[GIFModelDTO]>
    }

    struct Output {
        let dataSource: Driver<[SectionModel<Void, GIFModelDTO>]>
    }

    init(transform: @escaping (Input) -> Output) {
        self.transform = transform
    }

    convenience init() {
        self.init { input in
            Output(
                dataSource: Transforms.dataSource(input: input)
            )
        }
    }
}

private extension FavoritesViewModel {
    struct Transforms {
        static func dataSource(input: Input) -> Driver<[SectionModel<Void, GIFModelDTO>]> {
            return input.appStateFavorites                                
                .map(Mappings.toSource)
                .asDriver(onErrorJustReturn: [])
        }
    }
}

private extension FavoritesViewModel {
    struct Mappings {
        static func toSource(_ items: [GIFModelDTO]) -> [SectionModel<Void, GIFModelDTO>] {
            return [SectionModel(model: (), items: items)]
        }
    }
}
