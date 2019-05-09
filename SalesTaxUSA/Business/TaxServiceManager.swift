//
//  TaxServiceManager.swift
//  SalesTaxUSA
//
//  Created by Nagarjuna Madamanchi on 07/05/2019.
//  Copyright © 2019 Nagarjuna Madamanchi Ltd. All rights reserved.
//

import Foundation

extension Dictionary {
    public mutating func updateWithDict(_ secondDict: Dictionary) {
        self.merge(secondDict) { (current, _) in current }
    }
}

class TaxServiceManager {

    static let shared = TaxServiceManager()

    private init() {
        //..
    }

    public private(set) var items = [TaxItem]()
    public private(set) var selectedStateCode: String?
    public private(set) var discountRates = [Double : Double]()
    public private(set) var stateTaxRates = [String : Double]()

    static public let discountData:[Double : Double] = [
        1000.0 : 3.0,
        5000.0 : 5.0,
        7000.0 : 7.0,
        10000.0 : 10.0,
        50000.0 : 15.0
    ]
    static public let taxData:[String : Double] = [
        "UT": 6.85,
        "NV": 8.0,
        "TX": 6.25,
        "AL": 4.0,
        "CA": 8.25
    ]

    public func updateWithSampleData() {
        stateTaxRates.updateWithDict(TaxServiceManager.taxData)
        discountRates.updateWithDict(TaxServiceManager.discountData)
    }

    public func updateStateCodeWithData(_ data: String) {
        selectedStateCode = data
    }

    public func addItem(_ item: TaxItem) {
        items.append(item)
    }
}
