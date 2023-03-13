//
//	Condition.swift
//
//	Create by Mukesh Yadav on 5/4/2022

import Foundation

public struct CGCondition: Codable{
    var autoScroll : Bool = false
    var autoScrollSpeed : Int = 0
    var backgroundOpacity : Double = 0.0
    var delay : Int  = 0
    var draggable : Bool = false
    var priority : Int = 0
    var showCount : CGShowCount = CGShowCount(fromDictionary: [:])
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]) {
        autoScroll = dictionary["autoScroll"] as? Bool ?? false
        autoScrollSpeed = dictionary["autoScrollSpeed"] as? Int ?? 0
        backgroundOpacity = dictionary["backgroundOpacity"] as? Double ?? 0.0
        delay = dictionary["delay"] as? Int ?? 0
        draggable = dictionary["draggable"] as? Bool ?? false
        priority = dictionary["priority"] as? Int ?? 0
        if let showCountData = dictionary["showCount"] as? [String:Any] {
            showCount = CGShowCount(fromDictionary: showCountData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any] {
        var dictionary = [String:Any]()
        dictionary["autoScroll"] = autoScroll
        dictionary["autoScrollSpeed"] = autoScrollSpeed
        dictionary["backgroundOpacity"] = backgroundOpacity
        dictionary["delay"] = delay
        dictionary["draggable"] = draggable
        dictionary["priority"] = priority
        dictionary["showCount"] = showCount.toDictionary()
        return dictionary
    }
}
