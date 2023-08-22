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
                print("sdf: \(CGProxyHelper.shared.convertToMultilineJSON(response ?? ""))")
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
    
    func unescape(_ jsonString: String) -> String {
        var unescapedString = jsonString
        unescapedString = unescapedString.replacingOccurrences(of: "\\\"", with: "\"")
        unescapedString = unescapedString.replacingOccurrences(of: "\\\\n", with: "\n")
        return unescapedString
    }

    func convertToMultilineJSON(_ jsonString: String) -> String? {
        let unescapedJSONString = unescape(jsonString)
        
        guard let jsonData = unescapedJSONString.data(using: .utf8) else {
            return nil
        }
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            let prettyJSONData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            
            if let prettyJSONString = String(data: prettyJSONData, encoding: .utf8) {
                return prettyJSONString
            } else {
                return nil
            }
        } catch {
            print("Error parsing JSON: \(error)")
            return nil
        }
    }
}
