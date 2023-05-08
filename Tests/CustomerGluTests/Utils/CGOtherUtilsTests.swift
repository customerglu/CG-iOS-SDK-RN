//
//  CGOtherUtilsTests.swift
//  
//
//  Created by Ankit Jain on 08/05/23.
//

import XCTest
@testable import CustomerGlu

// MARK: - CGEncryptDecryptTests
final class CGOtherUtilsTests: CGBaseTestCase {
    var otherUtils: OtherUtils?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        otherUtils = OtherUtils.shared
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testConvertToDictionary() {
        // CASE 1 :: Valid JSON
        let jsonText = "{\"data\":{\"bannerID\":\"BANNER_ID_TEST\",\"pref_url\":\"about:config\"}}"
        let dict = otherUtils?.convertToDictionary(text: jsonText)
        if let dict {
            XCTAssertTrue(((dict["data"] as? [AnyHashable: Any]) != nil))
            
            let data = dict["data"] as? [AnyHashable: Any] ?? [:]
            XCTAssertTrue(data["bannerID"] as! String == "BANNER_ID_TEST")
            XCTAssertTrue(data["pref_url"] as! String == "about:config")
        } else {
            XCTAssertThrowsError("Failed to convert Json to Dict")
        }
        
        // CASE 2 :: Invalid JSON String
        let invalidJsonText = "{\"data\"{\"bannerID\"\"BANNER_ID_TEST\"\"pref_url\":\"about:config\"}}"
        let invalidDict = otherUtils?.convertToDictionary(text: invalidJsonText)
        XCTAssertNil(invalidDict)
    }
    
    func testGetCrashInfo() {
        let crashInfo = otherUtils?.getCrashInfo()
        XCTAssertNotNil(crashInfo)
        
        if let crashInfo {
            XCTAssertNotNil(crashInfo["os_version"])
            XCTAssertNotNil(crashInfo["app_name"])
            XCTAssertNotNil(crashInfo["platform"])
            XCTAssertNotNil(crashInfo["timezone"])
            XCTAssertNotNil(crashInfo["app_version"])
            XCTAssertNotNil(crashInfo["device_name"])
            XCTAssertNotNil(crashInfo["timestamp"])
            XCTAssertNotNil(crashInfo["device_id"])
        }
    }

    func testGetUniqueEntryData() {
        // Construct Data
        let data1 = CGData(fromDictionary: ["_id": "1"])
        let data2 = CGData(fromDictionary: ["_id": "2"])
        let data3 = CGData(fromDictionary: ["_id": "3"])
        let data4 = CGData(fromDictionary: ["_id": "4"])
        
        // CASE 1 :: Return Unique Data
        // Input Array
        var inputDataArray1: [CGData] = [data1, data2, data3]
        var inputDataArray2: [CGData] = [data1, data3, data4]
        
        // Here the comparision is to get all unique data in array2 when compared to array1 -> So output should return data4
        var outputDataArray = otherUtils?.getUniqueEntryData(fromExistingData: inputDataArray1, byComparingItWithNewEntryData: inputDataArray2) ?? []
        XCTAssertTrue(outputDataArray.count > 0)
        XCTAssertTrue(outputDataArray[0]._id == "4")
        
        
        // CASE 2 :: Return No Unique Data
        inputDataArray1 = [data1, data2, data3, data4]
        inputDataArray2 = [data1, data3, data4]
        
        // Here the comparision is to get all unique data in array2 when compared to array1 -> So output will not return any unique data
        outputDataArray = otherUtils?.getUniqueEntryData(fromExistingData: inputDataArray1, byComparingItWithNewEntryData: inputDataArray2) ?? []
        XCTAssertTrue(outputDataArray.count == 0)
    }
}
