//
//  ItemsListPresenter.swift
//  DolyameSDKUsageDemo
//
//  Created by a.tonkhonoev on 29.11.2021.
//

import Foundation

class ItemsListPresenter {
    class Navigation {
        var onClose: (() -> Void)?
        var onSave: (([CheckoutItemModel]) -> Void)?
        var onAddItem: (() -> Void)?
    }

    let navigation = Navigation()

    weak var view: IItemsListViewInput?
    private var model: [CheckoutItemModel]

    // MARK: - Initializer

    init(model: [CheckoutItemModel]) {
        self.model = model
    }

    // MARK: - Internal

    func addNewItem(_ item: CheckoutItemModel) {
        model.append(item)
        updateView(model: model)
    }
}

extension ItemsListPresenter: IItemsListViewOutput {
    func onViewDidLoad() {
        updateView(model: model)
    }

    func onAddItem() {
        navigation.onAddItem?()
    }

    func onSave() {
        navigation.onSave?(model)
    }

    func onClose() {
        navigation.onClose?()
    }

    func updateModel(objects: [ItemsListCellObject]) {
        let newModel = objects.map {
            CheckoutItemModel(name: $0.name,
                              quantity: $0.quantity,
                              price: $0.price,
                              sku: $0.sku)
        }
        model = newModel
    }

    // MARK: - Private

    private func updateView(model: [CheckoutItemModel]) {
        let itemsObjects = model.map {
            ItemsListCellObject(name: $0.name,
                                quantity: $0.quantity,
                                price: $0.price,
                                sku: $0.sku)
        }
        view?.update(objects: itemsObjects)
    }
}
