import uFeatures
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var appCoodinator: AppCoordinator!

    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DependencyInjector.load()
        window = UIWindow(frame: UIScreen.main.bounds)
        self.appCoodinator = AppCoordinator(window: window!)
        self.appCoodinator.start()
        window?.makeKeyAndVisible()
        return true
    }
}
