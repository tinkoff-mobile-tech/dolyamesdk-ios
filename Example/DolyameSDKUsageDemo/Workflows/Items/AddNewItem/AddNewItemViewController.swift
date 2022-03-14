//
//  AddNewItemViewController.swift
//  DolyameSDKUsageDemo
//
//  Created by a.tonkhonoev on 29.11.2021.
//

import SnapKit
import UIKit

class AddNewItemViewController: UIViewController {

    private let presenter: IAddNewItemViewOutput
    private let inputValueValidator: IInputValueValidator

    private let nameParamView = ModifiableParameterView()
    private let quantityParamView = ModifiableParameterView()
    private let priceParamView = ModifiableParameterView()
    private let skuParamView = ModifiableParameterView()
    private let saveButton = UIButton(type: .system)
    private let stackView = UIStackView()

    // MARK: - Initializer & Deinitializer

    init(presenter: IAddNewItemViewOutput,
         inputValueValidator: IInputValueValidator) {
        self.presenter = presenter
        self.inputValueValidator = inputValueValidator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View's lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.onViewDidLoad()
    }

    // MARK: - Actions

    @objc private func onCloseTouched() {
        presenter.onClose()
    }

    @objc private func onSaveTouched() {
        let name = inputValueValidator.validateStringValue(textField: nameParamView.textField)
        let quantity = inputValueValidator.validateIntValue(textField: quantityParamView.textField)
        let price = inputValueValidator.validateDecimalValue(textField: priceParamView.textField)
        let sku = inputValueValidator.replaceEmptyStringWithNil(textField: skuParamView.textField)

        if let name = name,
            let quantity = quantity,
            let price = price {
            let inputData = ItemInputData(name: name,
                                          quantity: quantity,
                                          price: price,
                                          sku: sku)
            presenter.onSave(with: inputData)
        }
    }

    // MARK: - Private

    private func setupView() {
        title = "Добавить новый товар"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Закрыть", style: .plain, target: self, action: #selector(onCloseTouched))

        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }

        stackView.axis = .vertical
        stackView.spacing = 2
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }

        stackView.addArrangedSubview(nameParamView)
        nameParamView.label.text = "name"
        stackView.addArrangedSubview(quantityParamView)
        quantityParamView.label.text = "quantity"
        stackView.addArrangedSubview(priceParamView)
        priceParamView.label.text = "price"
        stackView.addArrangedSubview(skuParamView)
        skuParamView.label.text = "sku"

        stackView.addArrangedSubview(saveButton)
        saveButton.setTitle("Сохранить", for: .normal)

        saveButton.addTarget(self, action: #selector(onSaveTouched), for: .touchUpInside)
    }
}

extension AddNewItemViewController: IAddNewItemViewInput {

    func updateView(with inputData: ItemInputData) {
        nameParamView.textField.text = inputData.name
        quantityParamView.textField.text = "\(inputData.quantity)"
        priceParamView.textField.text = "\(inputData.price)"
    }
}
