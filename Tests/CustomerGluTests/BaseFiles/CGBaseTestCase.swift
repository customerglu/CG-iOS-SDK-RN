//
//  CGBaseTestCase.swift
//  
//
//  Created by Ankit Jain on 21/02/23.
//

import XCTest

class CGBaseTestCase: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func failTestCase() {
        XCTAssertTrue(1 == 0)
    }
}
