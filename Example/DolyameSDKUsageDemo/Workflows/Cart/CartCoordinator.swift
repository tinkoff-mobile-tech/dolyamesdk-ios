import UIKit

class CartCoordinator {
    let modalHostController: UIViewController
    var checkoutCoordinator: CheckoutCoordinator?

    init(modalHostController: UIViewController) {
        self.modalHostController = modalHostController
    }

    func start() {
        let cartViewController = CartViewController()

        cartViewController.onCheckoutRequested = { [weak self, unowned cartViewController] in
            guard let self = self else { return }

            let checkoutCoordinator = CheckoutCoordinator(modalHostController: cartViewController)
            self.checkoutCoordinator = checkoutCoordinator

            checkoutCoordinator.onFinish = { [weak self] in
                self?.checkoutCoordinator = nil
            }

            checkoutCoordinator.start()
        }

        modalHostController.present(cartViewController, animated: true)
    }
}
