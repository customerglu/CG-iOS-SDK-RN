//
//  CGOnboardingSDKNotificationConfig.swift
//  
//
//  Created by Ankit Jain on 19/04/23.
//

import Foundation

public class CGClientTestingModel: Codable {
    var success: Bool?
    var data: String?
    var error: CGClientTestingErrorModel?
}

public class CGClientTestingErrorModel: Codable {
    var message: String?
}
