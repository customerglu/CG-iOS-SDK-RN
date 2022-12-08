//
//	CGAppConfig.swift
//
//	Create by Mukesh Yadav on 6/12/2022

import Foundation
import UIKit

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
    public var disableSdk: Bool? = CustomerGlu.sdk_disable
    public var enableAnalytics: Bool? = CustomerGlu.analyticsEvent
    public var enableEntryPoints: Bool? = CustomerGlu.isEntryPointEnabled
    public var errorCodeForDomain: Int? = CustomerGlu.doamincode
    public var errorMessageForDomain: String? = CustomerGlu.textMsg
    public var iosSafeArea: CGIosSafeArea? = CGIosSafeArea()
    public var loadScreenColor: String? = CustomerGlu.defaultBGCollor.hexString
    public var loaderColor: String? = CustomerGlu.arrColor[0].hexString
    public var whiteListedDomains: [String]? = CustomerGlu.whiteListedDomains
}

public class CGIosSafeArea: Codable {

    public var bottomColor: String? = CustomerGlu.bottomSafeAreaColor.hexString
    public var bottomHeight: Int? = CustomerGlu.bottomSafeAreaHeight
    public var topColor: String? = CustomerGlu.topSafeAreaColor.hexString
    public var topHeight: Int? = CustomerGlu.topSafeAreaHeight
}

//public class CGWeb: Codable {
//}



