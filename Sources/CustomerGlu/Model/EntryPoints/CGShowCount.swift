//
//	ShowCount.swift
//
//	Create by Mukesh Yadav on 24/3/2022

import Foundation

public struct CGShowCount: Codable{

	var dailyRefresh : Bool!
    var count: Int!

	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		dailyRefresh = dictionary["dailyRefresh"] as? Bool
        count = dictionary["count"] as? Int
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if dailyRefresh != nil{
			dictionary["dailyRefresh"] = dailyRefresh
		}
        if count != nil{
            dictionary["count"] = count
        }
		return dictionary
	}

}
