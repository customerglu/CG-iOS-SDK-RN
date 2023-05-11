//
//  CGExtesionsTests.swift
//  
//
//  Created by Ankit Jain on 08/05/23.
//

import XCTest
import UIKit
@testable import CustomerGlu

// MARK: - CGExtesionsTests
final class CGExtesionsTests: CGBaseTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - extension Dictionary Test Cases
    func testJSONFromDictionary() {
        let inputDict: [AnyHashable: Any] = ["data":["bannerID": "BANNER_ID_TEST","pref_url": "about:config"]]
        
        let actualOutput = inputDict.json
        let expectedOutput = "{\n  \"data\" : {\n    \"bannerID\" : \"BANNER_ID_TEST\",\n    \"pref_url\" : \"about:config\"\n  }\n}"

        XCTAssertTrue(actualOutput == expectedOutput)
    }
    
    // MARK: - extension String Test Cases
    func testReplaceStringWithText() {
        // CASE 1 :: When replacement string available
        var inputStr = "This is a test string, for extension test case replace 1234"
        var output = inputStr.replace(string: "1234", replacement: "5678")
        XCTAssertTrue(output == "This is a test string, for extension test case replace 5678")
        
        // CASE 2 :: When replacement string not available
        inputStr = "This is a test string, for extension test case replace"
        output = inputStr.replace(string: "1234", replacement: "5678")
        XCTAssertTrue(output == "This is a test string, for extension test case replace")
    }
    
    func testTrimSpace() {
        // CASE 1 :: With white space
        var inputStr = "Test string with spaces      "
        var output = inputStr.trimSpace()
        XCTAssertTrue(output == "Test string with spaces")
        
        // CASE 2 :: with new line character
        inputStr = "Test string with spaces \n"
        output = inputStr.trimSpace()
        XCTAssertTrue(output == "Test string with spaces")
    }
    
    func testFromBase64String() {
        // CASE 1 :: Test Message
        let testMessageStr = "dGVzdCBtZXNzYWdl"
        var output = testMessageStr.fromBase64()
        XCTAssertTrue(output == "test message")
        
        // CASE 2 :: CustomerGlu
        let customerGluStr = "Q3VzdG9tZXJHbHU="
        output = customerGluStr.fromBase64()
        XCTAssertTrue(output == "CustomerGlu")
        
        // Case 3 :: Wrong message with spelling mistake "Speling mistke"
        let spellingMistakeStr = "U3BlbGluZyBtaXN0a2U=" // This
        output = spellingMistakeStr.fromBase64()
        XCTAssertTrue(output == "Speling mistke")
        XCTAssertTrue(output != "Spelling mistake")
    }
    
    // MARK: - extension UIImageView Test Cases
    func testJPEGDownload() {
        let jpegUrlStr = "https://images.unsplash.com/photo-1533450718592-29d45635f0a9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2940&q=80"
        
        let imageview = UIImageView()
        imageview.downloadImage(urlString: jpegUrlStr) { image in
            XCTAssertNotNil(image)
        } failure: { _ in
            XCTAssertThrowsError("Failed to download image")
        }
    }
    
    func testGifDownload() {
        let gifUrlStr = "https://tenor.com/en-GB/view/triforce-heroes-link-zelda-the-legend-of-zelda-yay-gif-22678972"
        
        let imageview = UIImageView()
        imageview.downloadImage(urlString: gifUrlStr) { image in
            XCTAssertNotNil(image)
        } failure: { _ in
            XCTAssertThrowsError("Failed to download gif")
        }
    }
    
    func testBadImageUrlDownload() {
        let badUrlStr = "https://badurl.com/noimage/totest.jpeg"
        
        let imageview = UIImageView()
        imageview.downloadImage(urlString: badUrlStr) { image in
            // No image should be download
            XCTAssertNil(image)
        } failure: { _ in
            XCTAssertThrowsError("Failed to download")
        }
    }
    
    // MARK: - extension Date Test Cases
    
    func testCurrentTimeStamp() {
        let inputDate: Date = Date()
        let compareTimeStamp = Int64(inputDate.timeIntervalSince1970 * 1000)
        XCTAssertTrue(Date.currentTimeStamp == compareTimeStamp)
    }
    
    func testTomorrow() {
        let inputDate: Date = Date()
        let compareDate = Calendar.current.date(byAdding: .day, value: 1, to: inputDate)
        XCTAssertTrue(inputDate.tomorrow == compareDate)
    }
    
    // MARK: - extension UIColor Test Cases
    func testHexString() {
        // White Color
        let whiteHexString = UIColor.white.hexString
        XCTAssertTrue(whiteHexString == "#FFFFFFFF")
        
        // Black Color
        let blackHexString = UIColor.black.hexString
        XCTAssertTrue(blackHexString == "#000000FF")
    }
    
}
