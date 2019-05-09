//
//  SalesTaxOutputVC.swift
//  SalesTaxUSA
//
//  Created by Nagarjuna Madamanchi on 08/05/2019.
//  Copyright © 2019 Nagarjuna Madamanchi Ltd. All rights reserved.
//

import UIKit

class SalesTaxOutputVC: UIViewController {

    @IBOutlet weak var myTable: UITableView!
    @IBOutlet weak var totalWithoutTaxesTextField: UITextField!
    @IBOutlet weak var discountTextField: UITextField!
    @IBOutlet weak var taxTextField: UITextField!
    @IBOutlet weak var totalPriceTextField: UITextField!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!

    let cellID = "salesTaxCell"

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    private func updateViewController() {
        var totalWithoutTaxes: Double = 0.0
        var discountPercent: Double = 0.0
        var discountValue: Double = 0.0
        var taxPercent: Double = 0.0
        var taxValue: Double = 0.0
        var totalPriceValue: Double = 0.0

        func performUpdate() {
            fillTextFieldsWithValues(totalWithoutTaxes: totalWithoutTaxes,
                                     discountValue: discountValue,
                                     taxValue: taxValue,
                                     totalPriceValue: totalPriceValue,
                                     discountPercent: discountPercent,
                                     taxPercent: taxPercent)

            myTable.reloadData()
        }

        guard TaxServiceManager.shared.items.count > 0 else {
            performUpdate()
            let message = NSLocalizedString("No data.", comment: "")
            showMessageWithCompletionBlok(message) {
            }
            return
        }

        guard let stateCode = TaxServiceManager.shared.selectedStateCode else {
            performUpdate()
            let message = NSLocalizedString("State code is missing.", comment: "")
            showMessageWithCompletionBlok(message) {
            }
            return
        }

        // compute total without taxes
        for item in TaxServiceManager.shared.items {
            totalWithoutTaxes += item.unitPrice
        }

        // compute discount percent and value
        var sortedDiscountKeys: [Double] = Array(TaxServiceManager.shared.discountRates.keys)
        sortedDiscountKeys = sortedDiscountKeys.sorted().reversed()
        for maxTotal in sortedDiscountKeys {
            if totalWithoutTaxes > maxTotal {
                if let val = TaxServiceManager.shared.discountRates[maxTotal] {
                    discountPercent = val
                    break
                }
            }
        }
        discountValue = totalWithoutTaxes * (discountPercent/100.0)

        // compute tax percent and value
        if let tax = TaxServiceManager.shared.stateTaxRates[stateCode] {
            taxPercent = tax
        }
        taxValue = (totalWithoutTaxes - discountValue) * (taxPercent/100.0)
        totalPriceValue = totalWithoutTaxes - discountValue + taxValue

        performUpdate()
    }

    private func fillTextFieldsWithValues(totalWithoutTaxes: Double,
                                          discountValue: Double,
                                          taxValue: Double,
                                          totalPriceValue: Double,
                                          discountPercent: Double,
                                          taxPercent: Double) {
        totalWithoutTaxesTextField.text = String(format: "%.2f", totalWithoutTaxes)
        discountTextField.text = String(format: "%.2f", discountValue)
        taxTextField.text = String(format: "%.2f", taxValue)
        totalPriceTextField.text = String(format: "%.2f", totalPriceValue)

        //discountLabel.text = String(format: "Discount %.2f%%", discountPercent )
        //taxLabel.text = String(format: "Tax %.2f%%", taxPercent)
    }
}

extension SalesTaxOutputVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaxServiceManager.shared.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SalesTaxItemCell

        let data = TaxServiceManager.shared.items[indexPath.row]
        myCell.item.text = data.itemLabel
        myCell.quantity.text = String(data.quantity)
        myCell.unitprice.text = String(format: "%.2f", data.unitPrice)
        myCell.totalprice.text = String(format: "%.2f", data.totalPrice)

        return myCell
    }
}


