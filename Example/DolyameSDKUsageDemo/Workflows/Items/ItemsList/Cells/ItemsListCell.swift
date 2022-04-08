//
//  ItemsListCell.swift
//  DolyameSDKUsageDemo
//
//  Created by a.tonkhonoev on 29.11.2021.
//

import UIKit

struct ItemsListCellObject {
    let name: String
    let quantity: Int
    let price: Decimal
    let sku: String?
}

class ItemsListCell: UITableViewCell {

    static let reuseIdentifier = "ItemsListCell"

    private let titleLabel = UILabel()
    private let quantityLabel = UILabel()
    private let priceLabel = UILabel()
    private let skuLabel = UILabel()

    // MARK: - Initializer

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Internal

    func configure(with model: ItemsListCellObject) {
        titleLabel.text = model.name
        quantityLabel.text = "\(model.quantity)x"
        priceLabel.text = "\(model.price) ₽"
        skuLabel.text = "SKU: \(model.sku ?? "")"
    }

    // MARK: - Private

    private func setup() {

        contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 1
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(12)
        }

        contentView.addSubview(quantityLabel)
        quantityLabel.numberOfLines = 1
        quantityLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.bottom.equalTo(titleLabel.snp.bottom)
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(8)
        }

        contentView.addSubview(priceLabel)
        priceLabel.numberOfLines = 1
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.bottom.equalTo(titleLabel.snp.bottom)
            make.trailing.equalToSuperview().inset(12)
            make.leading.equalTo(quantityLabel.snp.trailing).offset(8)
        }

        contentView.addSubview(skuLabel)
        skuLabel.numberOfLines = 1
        skuLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }
}
