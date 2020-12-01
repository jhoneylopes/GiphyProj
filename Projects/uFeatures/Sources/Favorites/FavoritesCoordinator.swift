import UIKit
import uCore

final class FavoritesCoordinator: Coordinator {
    private unowned let navigationController: UINavigationController
    private var controller: FavoritesViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.controller = FavoritesViewController()
    }

    func start() {
        if let controller = controller {
            let data = DependencyManager.resolve(DatabaseProviderProtocol.self).fetchData()
            AppState.shared.favorites.accept(data)
            navigationController.pushViewController(controller, animated: false)
        }
    }
}
