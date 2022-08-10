//
//  File.swift
//  
//
//  Created by Himanshu Trehan on 22/07/21.
//

import Foundation

@objc(RegistrationModel)
public class RegistrationModel: NSObject, Codable {
          public var success: Bool?
    @objc public var data: MyData?
}

@objc(MyData)
public class MyData: NSObject, Codable {
    @objc public var token: String?
    @objc public var user: User?
}

@objc(User)
public class User: NSObject, Codable {
    @objc public var id: String?
    @objc public var userId: String?
    @objc public var anonymousId: String?
    @objc public var gluId: String?
    @objc public var userName: String?
    @objc public var email: String?
    @objc public var phone: String?
    @objc public var cookieId: String?
    @objc public var appVersion: String?
    @objc public var client: String?
    @objc public var referralLink: String?
    @objc public var referredBy: String?
    @objc public var identities: Identities?
    @objc public var profile: Profile?
    @objc public var sessionId: String?
    @objc public var deviceId: String?
    @objc public var deviceType: String?
    @objc public var deviceName: String?
}

@objc(Identities)
public class Identities: NSObject, Codable {
    @objc public var facebook_id: String?
    @objc public var google_id: String?
    @objc public var android_id: String?
    @objc public var ios_id: String?
    @objc public var clevertap_id: String?
    @objc public var mparticle_id: String?
    @objc public var segment_id: String?
    @objc public var moengage_id: String?
}

@objc(Profile)
public class Profile: NSObject, Codable {
    @objc public var firstName: String?
    @objc public var lastName: String?
    @objc public var age: String?
    @objc public var city: String?
    @objc public var country: String?
    @objc public var timezone: String?
}
