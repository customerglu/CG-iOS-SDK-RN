//
//	CGDeeplink.swift
//
//	Create by Mukesh Yadav on 20/12/2022

import Foundation
import UIKit


public class CGDeeplink: Codable {

	var data: CGDeeplinkData?
	var message: String?
	var success: Bool?


}

public class CGDeeplinkData: Codable {

    var anonymous: Bool?
    var client: String?
    var container: CGDeepContainer?
    var content: CGDeepContent?


}

public class CGDeepContent: Codable {

    var campaignId: String?
    var closeOnDeepLink: Bool?
    var type: String?


}

public class CGDeepContainer: Codable {

    var absoluteHeight: Double?
    var relativeHeight: Double?
    var type: String?

}
