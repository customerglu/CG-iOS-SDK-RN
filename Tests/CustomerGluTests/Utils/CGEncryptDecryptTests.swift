//
//  CGEncryptDecryptTests.swift
//  
//
//  Created by Ankit Jain on 08/05/23.
//

import XCTest
@testable import CustomerGlu

// MARK: - CGEncryptDecryptTests
final class CGEncryptDecryptTests: CGBaseTestCase {
    var encryptDecrypt: EncryptDecrypt?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        encryptDecrypt = EncryptDecrypt.shared

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    

    func testRandomString() {
        // Test case 1 - Random string of length 10
        let randomStr = encryptDecrypt?.randomString(length: 10)
        XCTAssertNotNil(randomStr)
        if let randomStr {
            XCTAssertTrue(randomStr.count == 10)
        } else {
            XCTAssertThrowsError("Failed")
        }
    }
    
//    func testEncryptText() {
//        let testMessage = "test message"
//        KeychainService.save(testMessage, for: CGConstants.customerglu_encryptedKey)
//
//        let encrptedText = encryptDecrypt?.encryptText(str: testMessage) ?? ""
//        let decrptedText = encryptDecrypt?.decryptText(str: encrptedText)
//
//        XCTAssertTrue(decrptedText == testMessage)
//    }
}
