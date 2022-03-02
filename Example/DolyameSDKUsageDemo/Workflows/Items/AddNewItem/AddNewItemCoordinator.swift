//
//  AddNewItemCoordinator.swift
//  DolyameSDKUsageDemo
//
//  Created by a.tonkhonoev on 29.11.2021.
//

import UIKit

class AddNewItemCoordinator {
    let modalHostController: UIViewController

    var onNewItemAdded: ((CheckoutItemModel) -> Void)?

    init(modalHostController: UIViewController) {
        self.modalHostController = modalHostController
    }

    func start() {
        let presenter = AddNewItemPresenter()
        let viewController = AddNewItemViewController(presenter: presenter,
                                                      inputValueValidator: InputValueValidator())
        let navigationWrapper = UINavigationController(rootViewController: viewController)
        presenter.view = viewController

        presenter.navigation.onClose = { [weak viewController] in
            viewController?.dismiss(animated: true)
        }

        presenter.navigation.onSave = { [weak self, weak viewController] model in
            self?.onNewItemAdded?(model)
            viewController?.dismiss(animated: true)
        }

        modalHostController.present(navigationWrapper, animated: true)
    }
}
