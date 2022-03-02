//
//  CheckoutModel.swift
//  DolyameSDKUsageDemo
//
//  Created by a.tonkhonoev on 28.11.2021.
//

import Foundation

struct CheckoutModel {
    let isDemoFlow: Bool

    let notificationUrl: String?

    let orderId: String
    let orderAmount: Decimal
    let orderPrepaidAmount: Decimal
    var orderItems: [CheckoutItemModel]
    let orderMcc: Int

    let clientInfoId: String
    let clientInfoFirstName: String?
    let clientInfoLastName: String?
    let clientInfoMiddleName: String?
    let clientInfoPhone: String?
    let clientInfoBirthday: String?
    let clientInfoEmail: String?
}

struct CheckoutItemModel {
    let name: String
    let quantity: Int
    let price: Decimal
    let sku: String?
}
