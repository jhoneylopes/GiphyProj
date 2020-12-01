import uCore
import RxSwift
import RxCocoa
import RxDataSources

final class HomeViewModel: ViewModel {
    var transform: (Input) -> Output

    struct Input {
        let searchInteraction: Observable<String?>
        let provider: Observable<SearchResult<GIFModelDTO>>
    }

    struct Output {
        let dataSource: Driver<[SectionModel<Void, GIFModelDTO>]>
        let search: Driver<String?>
    }

    init(transform: @escaping (Input) -> Output) {
        self.transform = transform
    }

    convenience init() {
        self.init { input in
            Output(
                dataSource: Transforms.dataSource(input: input),
                search: Transforms.search(input: input)
            )
        }
    }
}

private extension HomeViewModel {
    struct Transforms {
        static func dataSource(input: Input) -> Driver<[SectionModel<Void, GIFModelDTO>]> {
            return input.provider.map{ $0.data }                
                .map(Mappings.toSource)
                .asDriver(onErrorJustReturn: [])
        }

        static func search(input: Input) -> Driver<String?> {
            return input.searchInteraction
                .debounce(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
                .distinctUntilChanged()
                .asDriver(onErrorJustReturn: String())
        }
    }
}

private extension HomeViewModel {
    struct Mappings {
        static func toSource(_ items: [GIFModelDTO]) -> [SectionModel<Void, GIFModelDTO>] {
            return [SectionModel(model: (), items: items)]
        }
    }
}
