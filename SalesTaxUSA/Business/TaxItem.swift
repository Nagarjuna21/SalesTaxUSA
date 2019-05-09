//
//  TaxItem.swift
//  SalesTaxUSA
//
//  Created by Nagarjuna Madamanchi on 07/05/2019.
//  Copyright © 2019 Nagarjuna Madamanchi Ltd. All rights reserved.
//

import Foundation


struct TaxItem {
    var itemLabel: String
    var quantity: NSInteger
    var unitPrice: Double
    var totalPrice: Double {
        return Double(quantity) * unitPrice
    }
}
