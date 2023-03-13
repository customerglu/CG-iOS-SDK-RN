//
//	Data.swift
//
//	Create by Mukesh Yadav on 5/4/2022

import Foundation

public struct CGData: Codable {
    var v : Int = 0
    var _id : String = ""
    var client : String = ""
    var consumer : String = ""
    var createdAt : String = ""
    var mobile : CGMobile = CGMobile(fromDictionary: [:])
    var status : String = ""
    var updatedAt : String = ""
    var visible : Bool = false
    var name : String = ""
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        v = dictionary["__v"] as? Int ?? 0
        _id = dictionary["_id"] as? String ?? ""
        client = dictionary["client"] as? String ?? ""
        consumer = dictionary["consumer"] as? String ?? ""
        createdAt = dictionary["createdAt"] as? String ?? ""
        if let mobileData = dictionary["mobile"] as? [String:Any] {
            mobile = CGMobile(fromDictionary: mobileData)
        }
        status = dictionary["status"] as? String ?? ""
        updatedAt = dictionary["updatedAt"] as? String ?? ""
        visible = dictionary["visible"] as? Bool ?? false
        name = dictionary["name"] as? String ?? ""
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        dictionary["__v"] = v
        dictionary["_id"] = _id
        dictionary["client"] = client
        dictionary["consumer"] = consumer
        dictionary["createdAt"] = createdAt
        dictionary["mobile"] = mobile.toDictionary()
        dictionary["status"] = status
        dictionary["updatedAt"] = updatedAt
        dictionary["visible"] = visible
        dictionary["name"] = name
        return dictionary
    }
}
