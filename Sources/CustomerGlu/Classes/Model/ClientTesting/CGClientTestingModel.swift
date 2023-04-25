//
//  CGOnboardingSDKNotificationConfig.swift
//  
//
//  Created by Ankit Jain on 19/04/23.
//

import Foundation

// MARK: - CGClientTestingModel
public class CGClientTestingModel: Codable {
    var success: Bool?
    var data: CGClientTestingDataModel?
    var error: CGClientTestingErrorModel?
}

// MARK: - CGClientTestingErrorModel
public class CGClientTestingErrorModel: Codable {
    var message: String?
}

// MARK: - CGClientTestingDataModel
public class CGClientTestingDataModel: Codable {
    var apnsDeviceToken: Bool?
    var firebaseToken: Bool?
    var privateKeyApns: Bool?
    var privateKeyFirebase: Bool?
}
