//
//	CGAppConfig.swift
//
//	Create by Mukesh Yadav on 6/12/2022

import Foundation

public class CGAppConfig: Codable {
    public var data: CGConnfigData?
    public var success: Bool?
}

public class CGConnfigData: Codable {

    public var mobile: CGMobileData?
//    public var web: CGWeb?
}

public class CGMobileData: Codable {

    public var androidStatusBarColor: String?
    public var disableSdk: Bool? = false
    public var enableAnalytics: Bool? = false
    public var enableEntryPoints: Bool? = false
    public var errorCodeForDomain: Int? = 404
    public var errorMessageForDomain: String? = ""
    public var iosSafeArea: CGIosSafeArea?
    public var loadScreenColor: String? = "#ffffffff"
    public var loaderColor: String? = "#000000"
    public var whiteListedDomains: [String]? = []
}

public class CGIosSafeArea: Codable {

    public var bottomColor: String? = "#ffffffff"
    public var bottomHeight: Double? = 34.0
    public var topColor: String? = "#ffffffff"
    public var topHeight: Double? = 44.0
}

//public class CGWeb: Codable {
//}



