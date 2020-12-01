import UIKit
import uCore

public final class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let tabs: AppCoordinatorTabs
    private let appearance: AppAppearance

    var childCoordinators: [Coordinator] = []

    public init(window: UIWindow) {
        self.window = window
        tabs = AppCoordinatorTabs()
        appearance = AppAppearance()

        let homeCoordinator = HomeCoordinator(navigationController: tabs.home)
        let favoritesCoordinator = FavoritesCoordinator(navigationController: tabs.favorites)

        childCoordinators = [
            homeCoordinator,
            favoritesCoordinator
        ]

        childCoordinators.forEach { $0.start() }
    }

    public func start() {
        window.makeKeyAndVisible()
        window.backgroundColor = .white
        appearance.apply()

        rootViewController()
    }

    private func rootViewController() {
        window.rootViewController = tabs.tabBarController        
    }
}
