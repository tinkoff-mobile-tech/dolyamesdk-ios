//
//  CheckoutPresenter.swift
//  DolyameSDKUsageDemo
//
//  Created by a.tonkhonoev on 26.11.2021.
//

import Foundation

class CheckoutPresenter {

    class Navigation {
        var onPayButtonTouched: ((CheckoutModel) -> Void)?
        var onItemsEditTouched: (([CheckoutItemModel]) -> Void)?
    }

    weak var view: ICheckoutViewInput?
    let navigation = Navigation()

    var model: CheckoutModel = CheckoutModel(isDemoFlow: false,
                                             notificationUrl: nil,
                                             orderId: UUID().uuidString,
                                             orderAmount: 6700,
                                             orderPrepaidAmount: 300,
                                             orderItems: [
                                                 .init(name: "Nike Revolution 5 White",
                                                       quantity: 1,
                                                       price: 4600.0,
                                                       sku: nil),
                                                 .init(name: "A Default Basketball",
                                                       quantity: 1,
                                                       price: 600.0,
                                                       sku: nil),
                                                 .init(name: "A Default Basketball 2",
                                                       quantity: 1,
                                                       price: 600.0,
                                                       sku: nil),
                                                 .init(name: "A Default Basketball 3",
                                                       quantity: 1,
                                                       price: 600.0,
                                                       sku: nil),
                                                 .init(name: "A Default Basketball 4",
                                                       quantity: 1,
                                                       price: 600.0,
                                                       sku: nil)
                                             ],
                                             orderMcc: 5137,
                                             clientInfoId: "9934",
                                             clientInfoFirstName: "Оксана",
                                             clientInfoLastName: "Чичваркин",
                                             clientInfoMiddleName: "Валерьевна",
                                             clientInfoPhone: "+79876874585",
                                             clientInfoBirthday: "17.10.1989",
                                             clientInfoEmail: nil)

    // MARK: - Internal

    func updateModel(with items: [CheckoutItemModel]) {
        model.orderItems = items
        updateView(model: model)
    }

    // MARK: - Private

    private func createInputData(model: CheckoutModel) -> CheckoutInputData {
        CheckoutInputData(isDemoFlow: model.isDemoFlow,
                          notificationUrl: model.notificationUrl,
                          orderId: model.orderId,
                          orderAmount: model.orderAmount,
                          orderPrepaidAmount: model.orderPrepaidAmount,
                          orderMcc: model.orderMcc,
                          clientInfoId: model.clientInfoId,
                          clientInfoFirstName: model.clientInfoFirstName,
                          clientInfoLastName: model.clientInfoLastName,
                          clientInfoMiddleName: model.clientInfoMiddleName,
                          clientInfoPhone: model.clientInfoPhone,
                          clientInfoBirthday: model.clientInfoBirthday,
                          clientInfoEmail: model.clientInfoEmail)
    }

    private func createModelWith(inputData: CheckoutInputData,
                                 orderItems: [CheckoutItemModel]) -> CheckoutModel {
        CheckoutModel(isDemoFlow: inputData.isDemoFlow,
                      notificationUrl: inputData.notificationUrl,
                      orderId: inputData.orderId,
                      orderAmount: inputData.orderAmount,
                      orderPrepaidAmount: inputData.orderPrepaidAmount,
                      orderItems: orderItems,
                      orderMcc: inputData.orderMcc,
                      clientInfoId: inputData.clientInfoId,
                      clientInfoFirstName: inputData.clientInfoFirstName,
                      clientInfoLastName: inputData.clientInfoLastName,
                      clientInfoMiddleName: inputData.clientInfoMiddleName,
                      clientInfoPhone: inputData.clientInfoPhone,
                      clientInfoBirthday: inputData.clientInfoBirthday,
                      clientInfoEmail: inputData.clientInfoEmail)
    }

    private func updateView(model: CheckoutModel) {
        let inputData = createInputData(model: model)
        view?.configure(with: inputData)
        view?.update(itemsCount: model.orderItems.count)
    }
}

// MARK: - ICheckoutViewOutput

extension CheckoutPresenter: ICheckoutViewOutput {

    func onViewDidLoad() {
        updateView(model: model)
    }

    func onItemsEdit() {
        navigation.onItemsEditTouched?(model.orderItems)
    }

    func onPayment(with inputData: CheckoutInputData) {
        model = createModelWith(inputData: inputData,
                                orderItems: model.orderItems)
        navigation.onPayButtonTouched?(model)
    }
}
