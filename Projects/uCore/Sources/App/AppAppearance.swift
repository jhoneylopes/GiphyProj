import UIKit

public final class AppAppearance: Appearance {
    public init() {}
    
    func navigationBar(_ navigationBar: UINavigationBar) {
        navigationBar.tintColor = UIColor(red: 0, green: 131.0 / 255.0, blue: 1, alpha: 1.0)
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .white
    }

    func barButtonItem(_ barButtonItem: UIBarButtonItem) {
        barButtonItem.setTitleTextAttributes(
            [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular),
                NSAttributedString.Key.foregroundColor: UIColor(red: 0, green: 131.0 / 255.0, blue: 1, alpha: 1.0)
            ],
            for: .normal
        )
    }

    func tabBar(_ tabBar: UITabBar) {
        tabBar.isTranslucent = false
        tabBar.tintColor = UIColor(red: 0, green: 131.0 / 255.0, blue: 1, alpha: 1.0)
    }

    func tabBarItem(_ tabBarItem: UITabBarItem) {
        tabBarItem.setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: UIFont.Weight.regular)
        ], for: .normal)
    }

    public func apply() {
        navigationBar(.appearance())
        barButtonItem(.appearance())
        tabBar(.appearance())
        tabBarItem(.appearance())
    }
}

private struct Colors {
    static let largeNavigationTitle = UIColor.darkGray
}
