import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher
import uCore

final class HomeViewController: UIViewController {
    private let INFINITE_SCROLL_INDEX_LIMIT: Int = 9

    private let viewModel: HomeViewModel    
    private let disposeBag = DisposeBag()
    private var searchTerms: String? = String()

    fileprivate let mainView: HomeView = HomeView()
    fileprivate var searchOffset: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    fileprivate var lastSearchOffset: Int = 0

    private let searchController: UISearchController = {
      let searchController = UISearchController(searchResultsController: nil)
      searchController.searchBar.placeholder = "Search for GIFs"
      return searchController
    }()

    private lazy var dataSource: RxTableViewSectionedReloadDataSource<SectionModel<Void, GIFModelDTO>> = { [weak self] in
        RxTableViewSectionedReloadDataSource<SectionModel<Void, GIFModelDTO>> { [weak self] _, tableView, indexPath, data in
            guard let self = self else { return .init() }

            let cell: HomeViewCell = tableView.dequeueReusableCell(for: indexPath)

            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.funColor(by: indexPath.row)

            Observable.just(data.images?.downsized?.url ?? String())
                .distinctUntilChanged()
                .bind(to: cell.rx.gifURL)
                .disposed(by: cell.disposeBag)

            Observable.just(data.id)
                .distinctUntilChanged()
                .map { [weak self] id -> Bool in
                    return self?.isFavorited(by: id) ?? false
                }.bind(to: cell.rx.isFavorited)
                .disposed(by: cell.disposeBag)

            cell.rx.favoriteDidTap.asDriver().drive(onNext: { [weak self] in
                guard let self = self else { return }
                let gifs = self.favoriteManager(gif: data)
                self.updateFavoriteList(with: gifs)
                self.save(gifs)
            }).disposed(by: cell.disposeBag)

            cell.rx.favoriteDidTap.asObservable()
                .map({ [weak self] in
                    return self?.isFavorited(by: data.id) ?? false
                })
                .bind(to: cell.rx.isFavorited)
                .disposed(by: cell.disposeBag)

            self.infiniteScroll(current: indexPath.row)

            return cell
        }
    }()

    private let serviceProvider: GiphySearchProviderProtocol
    private let databaseProvider: DatabaseProviderProtocol
    private let state: AppStateProtocol
    init(serviceProvider: GiphySearchProviderProtocol = DependencyManager.resolve(GiphySearchProviderProtocol.self),
         databaseProvider: DatabaseProviderProtocol = DependencyManager.resolve(DatabaseProviderProtocol.self),
         state: AppStateProtocol = AppState.shared) {
        self.viewModel = HomeViewModel()
        self.serviceProvider = serviceProvider
        self.databaseProvider = databaseProvider
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        self.view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.tableView.delegate = self        
        configureProperties()
        bind()
    }

    private func configureProperties() {
        searchController.searchBar.rx.setDelegate(self).disposed(by: disposeBag)
        navigationItem.searchController = searchController
        navigationItem.title = "GIFs by: Giphy"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func bind() {
        let binding = viewModel.transform(
            HomeViewModel.Input(
                searchInteraction: searchController.searchBar.rx.text.asObservable(),
                provider: state.source.asObservable()
            )
        )

        binding.dataSource
            .drive(mainView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        binding.search
            .map({($0, .zero)})
            .map(fetch)
            .drive()
            .disposed(by: disposeBag)        
    }

    internal func favoriteManager(gif: GIFModelDTO) -> [GIFModelDTO] {
        var newValue: [GIFModelDTO] = state.favorites.value
        if newValue.contains(where: { $0.id == gif.id }) {
            newValue.removeAll { $0.id == gif.id }
        } else {
            let dataSet: Set<GIFModelDTO> = Set<GIFModelDTO>(newValue + [gif])
            newValue = Array(dataSet)
        }
        return newValue
    }

    internal func updateFavoriteList(with gifs: [GIFModelDTO]) {
        state.favorites.accept(gifs)
    }

    internal func save(_ gifs: [GIFModelDTO]) {
        databaseProvider.save(data: gifs)
    }

    internal func infiniteScroll(current position: Int) {
        if (position % INFINITE_SCROLL_INDEX_LIMIT) == 0 &&
            (position / INFINITE_SCROLL_INDEX_LIMIT) > self.lastSearchOffset {
            fetch(searchTerms, lastSearchOffset + 1)
        }
    }

    internal func isFavorited(by id: String) -> Bool {
        return state.favorites.value.contains(where: { $0.id == id })
    }

    internal func fetch(_ text: String?, _ offset: Int) {
        lastSearchOffset = offset
        serviceProvider
            .fetch(text, offset)
            .subscribe()
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTerms = searchBar.text
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.dismiss(animated: true)
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.text = searchTerms
        return true
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return HomeViewCellDimensions.height
    }
}
