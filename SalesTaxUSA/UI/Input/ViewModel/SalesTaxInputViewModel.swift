//
//  SalesTaxInputViewModel.swift
//  SalesTaxUSA
//
//  Created by Nagarjuna Madamanchi on 07/05/2019.
//  Copyright © 2019 Nagarjuna Madamanchi Ltd. All rights reserved.
//

import Foundation

class SalesTaxInputModel {

    class func validateNameData(_ data: String?) -> (String?, NSError?) {
        guard var retData = data else {
            let err = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Name is mandatory."])
            return (nil, err)
        }

        retData = retData.trimmingCharacters(in: .whitespaces)
        guard retData.count > 0 else {
            let err = NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey : "Name is mandatory."])
            return (nil, err)
        }

        return (retData, nil)
    }

    class func validateQuantityData(_ data: String?) -> (NSInteger?, NSError?) {
        guard var someData = data else {
            let err = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Quantity is mandatory."])
            return (nil, err)
        }

        someData = someData.trimmingCharacters(in: .whitespaces)
        guard someData.count > 0 else {
            let err = NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey : "Quantity is mandatory."])
            return (nil, err)
        }

        guard let intValue = NSInteger(someData) else {
            let err = NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey : "Incorrect quantity value."])
            return (nil, err)
        }

        guard intValue > 0 else {
            let err = NSError(domain: "", code: -4, userInfo: [NSLocalizedDescriptionKey : "Quantity has to be positive value."])
            return (nil, err)
        }

        return (intValue, nil)
    }

    class func validatePriceData(_ data: String?) -> (Double?, NSError?) {
        guard var someData = data else {
            let err = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "Price is mandatory."])
            return (nil, err)
        }

        someData = someData.trimmingCharacters(in: .whitespaces)
        guard someData.count > 0 else {
            let err = NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey : "Price is mandatory."])
            return (nil, err)
        }

        guard let doubleValue = Double(someData) else {
            let err = NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey : "Incorrect price value."])
            return (nil, err)
        }

        guard doubleValue > 0.0 else {
            let err = NSError(domain: "", code: -4, userInfo: [NSLocalizedDescriptionKey : "Price has to be positive value."])
            return (nil, err)
        }

        return (doubleValue, nil)
    }


    class func validateStateCodeData(_ data: String?) -> (String?, NSError?) {
        guard var retData = data else {
            let err = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "State code is mandatory."])
            return (nil, err)
        }

        retData = retData.trimmingCharacters(in: .whitespaces)
        guard retData.count == 2 else {
            let err = NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey : "The state code must consist of two letters."])
            return (nil, err)
        }

        guard let _ = TaxServiceManager.shared.stateTaxRates[retData] else {
            let err = NSError(domain: "", code: -3, userInfo: [NSLocalizedDescriptionKey : "Incorrect state code."])
            return (nil, err)
        }

        return (retData, nil)
    }
}
