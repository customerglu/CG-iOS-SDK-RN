//
//  CGProxyHelper.swift
//  
//
//  Created by Yasir on 21/08/23.
//

import Foundation

class CGProxyHelper {
    static let shared = CGProxyHelper()
    private let userDefaults = UserDefaults.standard
    
    private init() { }
    
    func getProgram() -> Void {
        var campaignIds: [String : Any] = [:]
        
        for id in CustomerGlu.allCampaignsIds {
            campaignIds[id] = true
        }
        
        let campaignId: [String : Any] = [
            "campaignId" : campaignIds
        ]
        
        let request: NSDictionary = [
            "filter" : campaignId,
            "limit" : 10,
            "page" : 1
        ]
        
        print("Program Request Body is: \(request)")
        
        APIManager.getProgram(queryParameters: request) { result in
            switch result {
            case .success(let response):
                print("Got the response for program: \(String(describing: response))")
                if let response = response {
                    self.encryptUserDefaultKey(str: response, userdefaultKey: CGConstants.CGGetProgramResponse)
                }
            case .failure(let failure):
                print("Get program failed with error : \(failure.localizedDescription)")
            }
        }
    }
    
    func getReward() -> Void {
        var campaignIds: [String : Any] = [:]
        
        for id in CustomerGlu.allCampaignsIds {
            campaignIds[id] = true
        }
        
        let campaignId: [String : Any] = [
            "campaignId" : campaignIds
        ]
        
        let request: NSDictionary = [
            "filter" : campaignId,
            "limit" : 10,
            "page" : 1
        ]
        
        print("Reward Request Body is: \(request)")
        
        APIManager.getReward(queryParameters: request) { result in
            switch result {
            case .success(let response):
                if let response = response {
                    self.encryptUserDefaultKey(str: response, userdefaultKey: CGConstants.CGGetRewardResponse)
                }
                print("Got the response for reward: \(String(describing: response))")
            case .failure(let failure):
                print("Get reward failed with error : \(failure.localizedDescription)")
            }
        }
    }
    
    private func encryptUserDefaultKey(str: String, userdefaultKey: String) {
        self.userDefaults.set(EncryptDecrypt.shared.encryptText(str: str), forKey: userdefaultKey)
    }
}
