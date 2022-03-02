//
//  AddNewItemViewIO.swift
//  DolyameSDKUsageDemo
//
//  Created by a.tonkhonoev on 29.11.2021.
//

import Foundation

struct ItemInputData {
    let name: String
    let quantity: Int
    let price: Decimal
    let sku: String?
}

protocol IAddNewItemViewInput: AnyObject {
    func updateView(with inputData: ItemInputData)
}

protocol IAddNewItemViewOutput: AnyObject {
    func onViewDidLoad()
    func onClose()
    func onSave(with inputData: ItemInputData)
}
