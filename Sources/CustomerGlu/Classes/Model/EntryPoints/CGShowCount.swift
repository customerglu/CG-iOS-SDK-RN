//
//	ShowCount.swift
//
//	Create by Mukesh Yadav on 5/4/2022

import Foundation

public struct CGShowCount: Codable{
    
    var count : Int = 0
    var dailyRefresh : Bool = false
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        count = dictionary["count"] as? Int ?? 0
        dailyRefresh = dictionary["dailyRefresh"] as? Bool ?? false
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        dictionary["count"] = count
        dictionary["dailyRefresh"] = dailyRefresh
        return dictionary
    }
}
