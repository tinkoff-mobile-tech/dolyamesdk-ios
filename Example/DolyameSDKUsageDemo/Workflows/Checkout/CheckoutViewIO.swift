//
//  CheckoutViewIO.swift
//  DolyameSDKUsageDemo
//
//  Created by a.tonkhonoev on 28.11.2021.
//

import Foundation

struct CheckoutInputData {
    let isDemoFlow: Bool

    let notificationUrl: String?

    let orderId: String
    let orderAmount: Decimal
    let orderPrepaidAmount: Decimal
    let orderMcc: Int

    let clientInfoId: String
    let clientInfoFirstName: String?
    let clientInfoLastName: String?
    let clientInfoMiddleName: String?
    let clientInfoPhone: String?
    let clientInfoBirthday: String?
    let clientInfoEmail: String?
}

protocol ICheckoutViewInput: AnyObject {
    func configure(with inputData: CheckoutInputData)
    func update(itemsCount: Int)
}

protocol ICheckoutViewOutput: AnyObject {
    func onViewDidLoad()
    func onItemsEdit()
    func onPayment(with inputData: CheckoutInputData)
}
