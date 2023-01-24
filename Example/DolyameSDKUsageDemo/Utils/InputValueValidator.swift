//
//  InputValueValidator.swift
//  DolyameSDKUsageDemo
//
//  Created by a.tonkhonoev on 29.11.2021.
//

import UIKit

protocol IInputValueValidator: AnyObject {
    func validateStringValue(textField: UITextField) -> String?
    func validateDecimalValue(textField: UITextField) -> Decimal?
    func validateIntValue(textField: UITextField) -> Int?

    func replaceEmptyStringWithNil(textField: UITextField) -> String?
}

class InputValueValidator: IInputValueValidator {

    // MARK: - IInputValueValidator

    func validateStringValue(textField: UITextField) -> String? {
        if let text = textField.text,
            !text.isEmpty {
            return text
        } else {
            animateTextField(textField: textField)
            return nil
        }
    }

    func validateDecimalValue(textField: UITextField) -> Decimal? {
        if let text = textField.text,
            let value = Decimal(string: text) {
            return value
        } else {
            animateTextField(textField: textField)
            return nil
        }
    }

    func validateIntValue(textField: UITextField) -> Int? {
        if let text = textField.text,
            let value = Int(text) {
            return value
        } else {
            animateTextField(textField: textField)
            return nil
        }
    }

    func replaceEmptyStringWithNil(textField: UITextField) -> String? {
        if let string = textField.text {
            return string.isEmpty ? nil : string
        } else {
            return nil
        }
    }

    // MARK: - Private

    private func animateTextField(textField: UITextField) {
        let borderWidth = textField.layer.borderWidth
        let borderColor = textField.layer.borderColor
        UIView.animate(withDuration: 1.0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: 1.0,
                       options: [.curveLinear]) {
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1.0
        } completion: { _ in
            textField.layer.borderColor = borderColor
            textField.layer.borderWidth = borderWidth
        }
    }
}
