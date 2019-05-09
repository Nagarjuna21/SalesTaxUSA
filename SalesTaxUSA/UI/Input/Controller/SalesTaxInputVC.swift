//
//  SalesTaxInputVC.swift
//  SalesTaxUSA
//
//  Created by Nagarjuna Madamanchi on 07/05/2019.
//  Copyright © 2019 Nagarjuna Madamanchi Ltd. All rights reserved.
//

import UIKit


class SalesTaxInputVC: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        _ = validateStateCode(showMessages: false)
    }

    private func dismissKeyboard() {
        nameTextField.resignFirstResponder()
        quantityTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
        stateTextField.resignFirstResponder()
    }

    private func clearAllFields() {
        nameTextField.text = nil
        quantityTextField.text = nil
        priceTextField.text = nil
    }

    private func validateStateCode(showMessages: Bool) -> Bool {
        let doubleStateCodeResult = SalesTaxInputModel.validateStateCodeData(stateTextField.text)
        if let error = doubleStateCodeResult.1 {
            if showMessages {
                weak var weakself = self
                showMessageWithCompletionBlok(error.localizedDescription) {
                    weakself?.stateTextField.becomeFirstResponder()
                }
            }
        } else if let stateCode = doubleStateCodeResult.0 {
            TaxServiceManager.shared.updateStateCodeWithData(stateCode)
            return true

        } else {
            if showMessages {
                let message = NSLocalizedString("Unexpected error occured.", comment: "")
                showMessageWithCompletionBlok(message) {}
            }
        }

        return false
    }
}

extension SalesTaxInputVC: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        if textField.tag != 0 {
            return true
        }

        guard let text = textField.text else {
            return true
        }

        let newLength = text.count + string.count - range.length
        return newLength <= 2
    }

    @IBAction func textFieldDidChanged(_ sender: UITextField) {
        if sender.tag == 0 {
            sender.text = sender.text?.uppercased()
            _ = validateStateCode(showMessages: false)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 1: quantityTextField.becomeFirstResponder()
        case 2: priceTextField.becomeFirstResponder()
        case 3: nameTextField.becomeFirstResponder()
        default: nameTextField.becomeFirstResponder()
        }

        return true
    }

    @IBAction func touchOutOfFieldsDetected(_ sender: Any) {
        dismissKeyboard()
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        dismissKeyboard()

        let strNameResult = SalesTaxInputModel.validateNameData(nameTextField.text)
        if let error = strNameResult.1 {
            weak var weakself = self
            showMessageWithCompletionBlok(error.localizedDescription) {
                weakself?.nameTextField.becomeFirstResponder()
            }
            return
        }

        let intResult = SalesTaxInputModel.validateQuantityData(quantityTextField.text)
        if let error = intResult.1 {
            weak var weakself = self
            showMessageWithCompletionBlok(error.localizedDescription) {
                weakself?.quantityTextField.becomeFirstResponder()
            }
            return
        }

        let doubleResult = SalesTaxInputModel.validatePriceData(priceTextField.text)
        if let error = doubleResult.1 {
            weak var weakself = self
            showMessageWithCompletionBlok(error.localizedDescription) {
                weakself?.priceTextField.becomeFirstResponder()
            }
            return
        }

        if validateStateCode(showMessages: true) == false {
            return
        }

        if let itemValue = strNameResult.0,
            let quantityValue = intResult.0,
            let unitValue = doubleResult.0 {

            let item = TaxItem(itemLabel: itemValue, quantity: quantityValue, unitPrice: unitValue)
            TaxServiceManager.shared.addItem(item)

            weak var weakself = self
            let message = NSLocalizedString("New item has been added.", comment: "")
            showMessageWithCompletionBlok(message) {
                weakself?.clearAllFields()
            }

        } else {
            let message = NSLocalizedString("Unexpected error occured.", comment: "")
            showMessageWithCompletionBlok(message) {}
        }
    }
}

extension UIViewController {
    internal func showMessageWithCompletionBlok(_ text: String,
                                                completionBlock: @escaping () -> Void) {
        let alert = UIAlertController(title: nil,
                                      message: text,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                      style: .default) { action in
                                        completionBlock()
        })

        present(alert, animated: true)
    }
}
