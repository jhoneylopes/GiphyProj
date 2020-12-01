import UIKit

final class MainTabBarController: UITabBarController {}

final class AppCoordinatorTabs {
    let tabBarController: MainTabBarController

    init() {
        tabBarController = AppTabFactory.createTabBarController()
    }

    var home: UINavigationController {
        return tab(at: 0)
    }

    var favorites: UINavigationController {
        return tab(at: 1)
    }
}

private extension AppCoordinatorTabs {
    func tab<T: UIViewController>(at index: Int) -> T {
        let tab = tabBarController.viewControllers?[index]

        guard let typedTab = tab as? T else {
            fatalError("Expected view controller of type \(T.self) but got \(type(of: tab))")
        }

        return typedTab
    }
}

private final class AppTabFactory {
    static func createTabBarController() -> MainTabBarController {
        let tabBarController = MainTabBarController()
        tabBarController.viewControllers = [
            createHomeTab(),
            createFavoritesTab()
        ]
        tabBarController.selectedIndex = 0
        return tabBarController
    }

    static func createHomeTab() -> UINavigationController {
        let home = UINavigationController()
        home.tabBarItem = UITabBarItem(
            tabBarSystemItem: UITabBarItem.SystemItem.mostViewed,
            tag: 0
        )
        return home
    }

    static func createFavoritesTab() -> UINavigationController {
        let favorites = UINavigationController()
        favorites.navigationBar.prefersLargeTitles = true
        favorites.tabBarItem = UITabBarItem(
            tabBarSystemItem: UITabBarItem.SystemItem.favorites,
            tag: 1
        )
        return favorites
    }
}
