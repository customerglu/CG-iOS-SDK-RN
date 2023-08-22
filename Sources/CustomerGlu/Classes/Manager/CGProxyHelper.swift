//
//  CGProxyHelper.swift
//  
//
//  Created by Yasir on 21/08/23.
//

import Foundation

class CGProxyHelper {
    static let shared = CGProxyHelper()
    var programsObject: String = ""
    var rewardsObject: String = ""
    
    private init() { }
    
    func getProgram() -> Void {
        var campaignId: [String : Any] = [
            "7218f57f-85da-4ab3-94d0-dd05034ad6fe" : true
        ]
        
//        for id in CustomerGlu.allCampaignsIds {
//            campaignId[id] = true
//        }
        
        let request: NSDictionary = [
            "filter" : campaignId,
            "limit" : 1,
            "page" : 1
        ]
        
        APIManager.getProgram(queryParameters: request) { result in
            switch result {
            case .success(let response):
                self.programsObject = response ?? ""
            case .failure(let failure):
                print("Get program failed with error : \(failure.localizedDescription)")
            }
        }
    }
    
    func getReward() -> Void {
        var campaignId: [String : Any] = [
            "7218f57f-85da-4ab3-94d0-dd05034ad6fe" : true
        ]
        
//        for id in CustomerGlu.allCampaignsIds {
//            campaignId[id] = true
//        }
        
        
        let request: NSDictionary = [
            "filter" : campaignId,
            "limit" : 10,
            "page" : 1
        ]
        
        APIManager.getReward(queryParameters: request) { result in
            switch result {
            case .success(let response):
                self.rewardsObject = response ?? ""
            case .failure(let failure):
                print("Get reward failed with error : \(failure.localizedDescription)")
            }
        }
    }
}
