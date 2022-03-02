//
//  AddNewItemPresenter.swift
//  DolyameSDKUsageDemo
//
//  Created by a.tonkhonoev on 29.11.2021.
//

import Foundation

class AddNewItemPresenter {

    class Navigation {
        var onClose: (() -> Void)?
        var onSave: ((CheckoutItemModel) -> Void)?
    }

    let navigation = Navigation()

    weak var view: IAddNewItemViewInput?

    private var model: CheckoutItemModel = CheckoutItemModel(name: "Кроссовки Adidas ZX750",
                                                             quantity: 1,
                                                             price: 8000.0,
                                                             sku: UUID().uuidString)
}

extension AddNewItemPresenter: IAddNewItemViewOutput {
    func onViewDidLoad() {
        updateView(model: model)
    }

    func onClose() {
        navigation.onClose?()
    }

    func onSave(with inputData: ItemInputData) {
        model = CheckoutItemModel(name: inputData.name,
                                  quantity: inputData.quantity,
                                  price: inputData.price,
                                  sku: inputData.sku)
        navigation.onSave?(model)
    }

    // MARK: - Private

    private func updateView(model: CheckoutItemModel) {
        let inputData = ItemInputData(name: model.name,
                                      quantity: model.quantity,
                                      price: model.price,
                                      sku: model.sku)
        view?.updateView(with: inputData)
    }
}
