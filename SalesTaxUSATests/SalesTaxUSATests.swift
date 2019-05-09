//
//  SalesTaxUSATests.swift
//  SalesTaxUSATests
//
//  Created by Nagarjuna Madamanchi on 07/05/2019.
//  Copyright © 2019 Nagarjuna Madamanchi Ltd. All rights reserved.
//

import XCTest
@testable import SalesTaxUSA

class SalesTaxUSATests: XCTestCase {

    override func setUp() {
        TaxServiceManager.shared.updateWithSampleData()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testThatSampleDataAreLoaded() {
        let statesCounter = TaxServiceManager.shared.stateTaxRates.count
        let discountCounter = TaxServiceManager.shared.stateTaxRates.count

        print("states count: %d", statesCounter)
        print("discounts count: %d", discountCounter)

        XCTAssertTrue(discountCounter > 0)
        XCTAssertTrue(statesCounter > 0)
    }

    func testThatStateCodeValidationIsCorrect() {
        let code = "UT"
        let result = SalesTaxInputModel.validateStateCodeData(code)

        XCTAssertNotNil(result.0)
        XCTAssertNil(result.1)
    }

    func testThatStateCodeValidationCanCatchIncorrectCode() {
        let code = "MN"
        let result = SalesTaxInputModel.validateStateCodeData(code)

        XCTAssertNil(result.0)
        XCTAssertNotNil(result.1)
    }


}
