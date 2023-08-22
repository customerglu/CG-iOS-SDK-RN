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
                print("sdf: \(CGProxyHelper.shared.convertJSONStringToDictionary(jsonString: response ?? ""))")
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
                print("")
//                var jsonObject = self.getJSON(from: success)
            case .failure(let failure):
                print("")
            }
        }
    }

    func convertJSONStringToDictionary(jsonString: String) -> [String: Any]? {
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                if let jsonDictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                    return jsonDictionary
                } else {
                    print("Failed to convert JSON string to dictionary.")
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid JSON string data.")
        }
        return nil
    }

}
