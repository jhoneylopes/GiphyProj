import UIKit
import uCore
import RxSwift
import RxDataSources

final class FavoritesViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let customView: FavoritesView = FavoritesView()
    private let viewModel: FavoritesViewModel

    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<SectionModel<Void, GIFModelDTO>> = { [weak self] in
        RxCollectionViewSectionedReloadDataSource<SectionModel<Void, GIFModelDTO>> { [weak self] _, collectionView, indexPath, data in

            let cell: FavoritesViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.backgroundColor = UIColor.funColor(by: indexPath.row)
            
            Observable.just(data.images?.downsized?.url ?? String())
                .distinctUntilChanged()
                .bind(to: cell.rx.gifURL)
                .disposed(by: cell.disposeBag)

            cell.rx.unfavoriteDidTap.asDriver().drive(onNext: { [weak self] in
                guard let self = self else { return }
                let newValue = self.unfavoriteManager(gif: data)
                self.updateFavoriteList(with: newValue)
                self.save(newValue)
            }).disposed(by: cell.disposeBag)

            return cell
        }
    }()

    init(viewModel: FavoritesViewModel = FavoritesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        self.view = customView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureProperties()
        bind()
    }

    private func configureProperties() {
        navigationItem.title = "Favorites"
        customView.collectionView.rx.setDelegate(self).disposed(by: disposeBag)        
    }

    private func bind() {
        let binding = viewModel.transform(
            FavoritesViewModel.Input(
                appStateFavorites: AppState.shared.favorites.asObservable()                
            )
        )

        binding.dataSource
            .drive(customView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    internal func unfavoriteManager(gif: GIFModelDTO) -> [GIFModelDTO] {
        var newValue: [GIFModelDTO] = AppState.shared.favorites.value
        newValue.removeAll { $0.id == gif.id }
        return newValue
    }

    internal func updateFavoriteList(with gifs: [GIFModelDTO]) {
        AppState.shared.favorites.accept(gifs)
    }

    internal func save(_ gifs: [GIFModelDTO]) {
        DependencyManager.resolve(DatabaseProviderProtocol.self).save(data: gifs)
    }
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2
        return CGSize(width: width, height: width * 1.5)
    }
}
