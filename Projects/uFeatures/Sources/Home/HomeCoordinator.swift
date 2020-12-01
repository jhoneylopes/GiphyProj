import UIKit

final class HomeCoordinator: Coordinator {
    private unowned let navigationController: UINavigationController
    private var controller: HomeViewController?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.controller = HomeViewController()
    }

    func start() {
        if let controller = controller {
            navigationController.pushViewController(controller, animated: false)
        }
    }
}
