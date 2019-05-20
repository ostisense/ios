import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var window: UIWindow? = {
        let window = UIWindow(frame: UIScreen.main.bounds)
        return window
    }()

    lazy var introViewController: IntroViewController = {
        let introViewController = IntroViewController()
        return introViewController
    }()

    lazy var baseNavigationController: UINavigationController = {
        let baseNavigationController = UINavigationController(rootViewController: self.introViewController)
        return baseNavigationController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        createNavigationStack()
        return true
    }

    private func createNavigationStack() {
        window?.rootViewController = baseNavigationController
        window?.makeKeyAndVisible()
    }
}
