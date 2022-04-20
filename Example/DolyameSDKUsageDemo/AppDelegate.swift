import UIKit

@main class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: ApplicationCoordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window

        let appCoordinator = ApplicationCoordinator(hostWindow: window)
        self.appCoordinator = appCoordinator

        UINavigationBar.appearance().prefersLargeTitles = true
        UITableView.appearance().estimatedRowHeight = 0
        UITableView.appearance().sectionHeaderHeight = 0
        UITableView.appearance().estimatedSectionFooterHeight = 0

        appCoordinator.start()

        return true
    }
}
