//
//  ItemsListViewIO.swift
//  DolyameSDKUsageDemo
//
//  Created by a.tonkhonoev on 29.11.2021.
//

import Foundation

protocol IItemsListViewInput: AnyObject {
    func update(objects: [ItemsListCellObject])
}

protocol IItemsListViewOutput: AnyObject {
    func onViewDidLoad()
    func onAddItem()
    func onSave()
    func onClose()
    func updateModel(objects: [ItemsListCellObject])
}
