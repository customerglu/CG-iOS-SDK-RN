//
//	CGCondition.swift
//
//	Create by Mukesh Yadav on 10/3/2022

import Foundation

struct CGCondition: Codable{

	var autoScroll : Bool!
	var autoScrollSpeed : Int!
	var backgroundOpacity : Float!
	var delay : Int!
	var draggable : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		autoScroll = dictionary["autoScroll"] as? Bool
		autoScrollSpeed = dictionary["autoScrollSpeed"] as? Int
		backgroundOpacity = dictionary["backgroundOpacity"] as? Float
		delay = dictionary["delay"] as? Int
		draggable = dictionary["draggable"] as? Bool
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if autoScroll != nil{
			dictionary["autoScroll"] = autoScroll
		}
		if autoScrollSpeed != nil{
			dictionary["autoScrollSpeed"] = autoScrollSpeed
		}
		if backgroundOpacity != nil{
			dictionary["backgroundOpacity"] = backgroundOpacity
		}
		if delay != nil{
			dictionary["delay"] = delay
		}
		if draggable != nil{
			dictionary["draggable"] = draggable
		}
		return dictionary
	}

}
