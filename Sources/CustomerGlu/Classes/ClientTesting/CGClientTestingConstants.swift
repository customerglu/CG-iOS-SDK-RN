//
//  File.swift
//  
//
//  Created by Ankit Jain on 21/04/23.
//

import Foundation

// MARK: - CGClientTestingStatus
public enum CGClientTestingStatus: Int {
    case header
    case pending
    case success
    case failure
    
    func getStatusForSDKTestStepsAPI() -> String {
        switch self {
        case .success:
            return "SUCCESS"
        default:
            return "FAILURE"
        }
    }
}

// MARK: - CGCustomAlertTag
public enum CGCustomAlertTag: Int {
    case callbackHandingTag = 1001
    case nudgeHandlingTag = 1002
    case onelinkHandlingTag = 1003
}

// MARK: - CGClientTestingRowItem
public enum CGClientTestingRowItem {
    case basicIntegration(status: CGClientTestingStatus)
    case sdkInitialised(status: CGClientTestingStatus)
    case userRegistered(status: CGClientTestingStatus)
    case callbackHanding(status: CGClientTestingStatus)
    case advanceIntegration(status: CGClientTestingStatus)
    case nudgeHandling(status: CGClientTestingStatus)
    case onelinkHandling(status: CGClientTestingStatus)
    case entryPointSetup(status: CGClientTestingStatus)
    case entryPointScreeNameSetup(status: CGClientTestingStatus)
    case entryPointBannerIDSetup(status: CGClientTestingStatus)
    case entryPointEmbedIDSetup(status: CGClientTestingStatus)
    
    func getTitle() -> String {
        switch self {
        case .basicIntegration:
            return "Basic Integration"
        case .sdkInitialised:
            return "SDK Initialised"
        case .userRegistered:
            return "User Registered"
        case .callbackHanding:
            return "Callback Handing"
        case .advanceIntegration:
            return "Advance Integration"
        case .nudgeHandling:
            return "Nudge Handling"
        case .onelinkHandling:
            return "Onelink Handling"
        case .entryPointSetup:
            return "Entry Point Set up"
        case .entryPointScreeNameSetup:
            return "Entry Point Screen Name Set up"
        case .entryPointBannerIDSetup:
            return "Entry Point BannerId Set up"
        case .entryPointEmbedIDSetup:
            return "Entry Point EmbedId Set up"
        }
    }
    
    func getStatus() -> CGClientTestingStatus {
        switch self {
        case .basicIntegration(let status):
            return status
        case .sdkInitialised(let status):
            return status
        case .userRegistered(let status):
            return status
        case .callbackHanding(let status):
            return status
        case .advanceIntegration(let status):
            return status
        case .nudgeHandling(let status):
            return status
        case .onelinkHandling(let status):
            return status
        case .entryPointSetup(let status):
            return status
        case .entryPointScreeNameSetup(let status):
            return status
        case .entryPointBannerIDSetup(let status):
            return status
        case .entryPointEmbedIDSetup(let status):
            return status
        }
    }
    
    func getAlertTitleAndMessage() -> (title: String, message: String, tag: Int)? {
        switch self {
        case .basicIntegration:
            return nil
        case .sdkInitialised:
            return nil
        case .userRegistered:
            return nil
        case .callbackHanding:
            return ("CustomerGlu", "Do you receive callback?", CGCustomAlertTag.callbackHandingTag.rawValue)
        case .advanceIntegration:
            return nil
        case .nudgeHandling:
            return ("CustomerGlu", "Do you see a nudge?", CGCustomAlertTag.nudgeHandlingTag.rawValue)
        case .onelinkHandling:
            return ("CustomerGlu", "Has CG Deeplink successfully redirected?", CGCustomAlertTag.onelinkHandlingTag.rawValue)
        case .entryPointSetup:
            return nil
        case .entryPointScreeNameSetup:
            return nil
        case .entryPointBannerIDSetup:
            return nil
        case .entryPointEmbedIDSetup:
            return nil
        }
    }
    
    func getDocumentationURL() -> URL? {
        switch self {
        case .basicIntegration:
            return nil
        case .sdkInitialised:
            return URL(string: "https://docs.customerglu.com/sdk/mobile-sdks#initialise-sdk")
        case .userRegistered:
            return URL(string: "https://docs.customerglu.com/sdk/mobile-sdks#register-user-mandatory")
        case .callbackHanding:
            return URL(string: "https://docs.customerglu.com/sdk/mobile-sdks#handling-events")
        case .advanceIntegration:
            return nil
        case .nudgeHandling:
            return URL(string: "https://docs.customerglu.com/sdk/mobile-sdks#handle-customerglu-nudges")
        case .onelinkHandling:
            return URL(string: "https://docs.customerglu.com/sdk/mobile-sdks#handling-events")
        case .entryPointSetup:
            return URL(string: "https://docs.customerglu.com/sdk/mobile-sdks#enable-entry-points")
        case .entryPointScreeNameSetup:
            return URL(string: "https://docs.customerglu.com/sdk/mobile-sdks#setting-up-floating-buttons-and-popups")
        case .entryPointBannerIDSetup:
            return URL(string: "https://docs.customerglu.com/sdk/mobile-sdks#setting-up-banners")
        case .entryPointEmbedIDSetup:
            return URL(string: "https://docs.customerglu.com/sdk/mobile-sdks#setting-up-embed-view")
        }
    }
    
    func getSDKTestStepName() -> String {
        switch self {
        case .basicIntegration:
            return ""
        case .sdkInitialised:
            return "SDK_INITIALISED"
        case .userRegistered:
            return "USER_RESGISTERED"
        case .callbackHanding:
            return "CALLBACK_HANDLING"
        case .advanceIntegration:
            return ""
        case .nudgeHandling:
            return "NUDGE_HANDLING"
        case .onelinkHandling:
            return "ONELINK_HANDLING"
        case .entryPointSetup:
            return "ENTRY_POINT_SETUP"
        case .entryPointScreeNameSetup:
            return "ENTRY_POINT_SCREEN_NAME_SETUP"
        case .entryPointBannerIDSetup:
            return "ENTRY_POINT_BANNER_ID_SETUP"
        case .entryPointEmbedIDSetup:
            return "ENTRY_POINT_EMBED_ID_SETUP"
        }
    }
}

// MARK: - CGNudgeSubTask
public enum CGNudgeSubTask {
    case apnsDeviceToken(status: CGClientTestingStatus)
    case firebaseToken(status: CGClientTestingStatus)
    case privateKeyApns(status: CGClientTestingStatus)
    case privateKeyFirebase(status: CGClientTestingStatus)
    
    func getTitle() -> String {
        switch self {
        case .apnsDeviceToken:
            return "APNS Setup"
        case .firebaseToken:
            return "Firebase Setup"
        case .privateKeyApns:
            return "APNS Server Private Key Setup"
        case .privateKeyFirebase:
            return "Firebase Server Private Key Setup"
        }
    }
    
    func getStatus() -> CGClientTestingStatus {
        switch self {
        case .apnsDeviceToken(let status):
            return status
        case .firebaseToken(let status):
            return status
        case .privateKeyApns(let status):
            return status
        case .privateKeyFirebase(let status):
            return status
        }
    }
}

// MARK: - CGSDKTestStepsModel
struct CGSDKTestStepsModel {
    var name: CGClientTestingRowItem?
    var status: CGClientTestingStatus? // Should hold only success or failure
    var timestamp: Date = Date() // Whenever model is initialised the timestamp will be recorded.
    
    func asDictionary() -> [String: Any] {
        var data: [String: Any] = [:]
        if let name {
            data["name"] = name.getSDKTestStepName()
        }
        if let status {
            data["status"] = status.getStatusForSDKTestStepsAPI()
        }
        data["timestamp"] = timestamp.timeIntervalSince1970
        return data
    }
}

