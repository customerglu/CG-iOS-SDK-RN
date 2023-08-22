//
//  CGProxyHelper.swift
//  
//
//  Created by Yasir on 21/08/23.
//

import Foundation

class CGProxyHelper {
    static let shared = CGProxyHelper()
    
    private init() { }
    
    func getProgram() -> Void {
        var campaignId: [String : Any] = [:]
        
        for id in CustomerGlu.allCampaignsIds {
            campaignId[id] = true
        }
        
        let request: NSDictionary = [
            "filter" : campaignId,
            "limit" : 1,
            "page" : 1
        ]
        
        APIManager.getProgram(queryParameters: request) { result in
            switch result {
            case .success(let response):
                print("Got success with response: \(response)")
//                var jsonObject = self.getJSON(from: response)
            case .failure(let failure):
                print("Get program failed with error : \(failure.localizedDescription)")
            }
        }
    }
    
    func getReward() -> Void {
        var campaignId: [String : Any] = [:]
        
        for id in CustomerGlu.allCampaignsIds {
            campaignId[id] = true
        }
        
        
        let request: NSDictionary = [
            "filter" : campaignId,
            "limit" : 10,
            "page" : 1
        ]
        
        APIManager.getReward(queryParameters: request) { result in
            switch result {
            case .success(let success):
                var jsonObject = self.getJSON(from: success)
            case .failure(let failure):
                print("")
            }
        }
    }
    
    private func getJSON(from data: Data) -> [String : Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print("Error parsing JSON: \(error.localizedDescription)")
            return nil
        }
    }
    
    
}
