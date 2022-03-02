//
//  ItemsListCoordinator.swift
//  DolyameSDKUsageDemo
//
//  Created by a.tonkhonoev on 28.11.2021.
//

import UIKit

class ItemsListCoordinator {

    let modalHostController: UIViewController
    var onNewItemsAdded: (([CheckoutItemModel]) -> Void)?

    var items = [CheckoutItemModel]()

    private var addItemCoordinator: AddNewItemCoordinator?

    // MARK: - Initializer

    init(modalHostController: UIViewController) {
        self.modalHostController = modalHostController
    }

    // MARK: - Internal

    func start() {
        let presenter = ItemsListPresenter(model: items)
        let viewController = ItemsListViewController(presenter: presenter)
        presenter.view = viewController

        presenter.navigation.onAddItem = { [weak self] in
            self?.startAddItemFlow { model in
                presenter.addNewItem(model)
            }
        }

        presenter.navigation.onClose = {
            viewController.dismiss(animated: true)
        }

        presenter.navigation.onSave = { [weak self] model in
            self?.onNewItemsAdded?(model)
            viewController.dismiss(animated: true)
        }

        addItemCoordinator = AddNewItemCoordinator(modalHostController: viewController)

        let navigationWrapper = UINavigationController(rootViewController: viewController)
        modalHostController.present(navigationWrapper, animated: true)
    }

    // MARK: - Private

    private func startAddItemFlow(onSuccess: ((CheckoutItemModel) -> Void)?) {
        guard let addItemCoordinator = addItemCoordinator else {
            return
        }
        addItemCoordinator.onNewItemAdded = { model in
            onSuccess?(model)
        }
        addItemCoordinator.start()
    }
}
