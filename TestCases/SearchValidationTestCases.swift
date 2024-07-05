//
//  SearchValidationTestCases.swift
//  IMDB DemoTests
//
//  Created by Sumit on 04/07/24.
//

import XCTest
@testable import IMDB_Demo

final class SearchValidationTestCases: XCTestCase {

    

        func testValidSearchText() {
            XCTAssertTrue(SearchValidator.isValidSearchText("Inception"))
            XCTAssertTrue(SearchValidator.isValidSearchText("a"))
        }
        
        func testInvalidSearchText() {
            XCTAssertFalse(SearchValidator.isValidSearchText(""))
            XCTAssertFalse(SearchValidator.isValidSearchText(nil))
        }
    }
    
    
