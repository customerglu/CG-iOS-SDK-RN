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
    
    func getNudgeHandlingSubTypeArray() -> [CGNudgeSubTask] {
        var arr: [CGNudgeSubTask] = []
        if let flag = apnsDeviceToken {
            arr.append(.apnsDeviceToken(status: (flag) ? .success: .failure))
        } else {
            arr.append(.apnsDeviceToken(status: .pending))
        }
        
        if let flag = firebaseToken {
            arr.append(.firebaseToken(status: (flag) ? .success: .failure))
        } else {
            arr.append(.firebaseToken(status: .pending))
        }
        
        if let flag = privateKeyApns {
            arr.append(.privateKeyApns(status: (flag) ? .success: .failure))
        } else {
            arr.append(.privateKeyApns(status: .pending))
        }
        
        if let flag = privateKeyFirebase {
            arr.append(.privateKeyFirebase(status: (flag) ? .success: .failure))
        } else {
            arr.append(.privateKeyFirebase(status: .pending))
        }
        
        return arr
    }
}
