import UIKit

class ApplicationCoordinator {
    let hostWindow: UIWindow

    var cartCoordinator: CartCoordinator?

    init(hostWindow: UIWindow) {
        self.hostWindow = hostWindow
    }

    func start() {
        let emptyViewController = UIViewController(nibName: nil, bundle: nil)
        emptyViewController.view.backgroundColor = UIColor(white: 0.9, alpha: 1)

        hostWindow.rootViewController = emptyViewController

        let cartCoordinator = CartCoordinator(modalHostController: emptyViewController)
        self.cartCoordinator = cartCoordinator

        cartCoordinator.start()
    }
}
