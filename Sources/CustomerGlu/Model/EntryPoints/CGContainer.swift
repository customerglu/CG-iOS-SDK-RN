//
//	Container.swift
//
//	Create by Mukesh Yadav on 24/3/2022

import Foundation

public struct CGContainer: Codable{

	var elementId : String!
	var height : String!
	var position : String!
	var type : String!
	var width : String!
    var borderRadius : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		elementId = dictionary["elementId"] as? String
		height = dictionary["height"] as? String
		position = dictionary["position"] as? String
		type = dictionary["type"] as? String
		width = dictionary["width"] as? String
        borderRadius = dictionary["borderRadius"] as? String
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if elementId != nil{
			dictionary["elementId"] = elementId
		}
		if height != nil{
			dictionary["height"] = height
		}
		if position != nil{
			dictionary["position"] = position
		}
		if type != nil{
			dictionary["type"] = type
		}
		if width != nil{
			dictionary["width"] = width
		}
        if borderRadius != nil{
            dictionary["borderRadius"] = borderRadius
        }
		return dictionary
	}

}
