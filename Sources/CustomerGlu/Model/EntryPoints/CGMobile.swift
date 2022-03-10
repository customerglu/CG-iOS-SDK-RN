//
//	CGMobile.swift
//
//	Create by Mukesh Yadav on 10/3/2022

import Foundation

struct CGMobile: Codable{

	var id : String!
	var conditions : CGCondition!
	var container : CGContainer!
	var content : [CGContent]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: [String:Any]){
		id = dictionary["_id"] as? String
		if let conditionsData = dictionary["conditions"] as? [String:Any]{
				conditions = CGCondition(fromDictionary: conditionsData)
			}
		if let containerData = dictionary["container"] as? [String:Any]{
				container = CGContainer(fromDictionary: containerData)
			}
		content = [CGContent]()
		if let contentArray = dictionary["content"] as? [[String:Any]]{
			for dic in contentArray{
				let value = CGContent(fromDictionary: dic)
				content.append(value)
			}
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if id != nil{
			dictionary["_id"] = id
		}
		if conditions != nil{
			dictionary["conditions"] = conditions.toDictionary()
		}
		if container != nil{
			dictionary["container"] = container.toDictionary()
		}
		if content != nil{
			var dictionaryElements = [[String:Any]]()
			for contentElement in content {
				dictionaryElements.append(contentElement.toDictionary())
			}
			dictionary["content"] = dictionaryElements
		}
		return dictionary
	}

}
