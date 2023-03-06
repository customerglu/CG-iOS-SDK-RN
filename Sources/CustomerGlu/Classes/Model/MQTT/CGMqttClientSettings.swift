//
//  File.swift
//  
//
//  Created by Ankit Jain on 06/03/23.
//

import Foundation

public struct CGMqttSettings {
    var username: String!
    var password: String!
    var token: String!
    var serverHost: String!
    var topic: String!
    var port: UInt16!
    
    public init(username: String, password: String, token: String, serverHost: String, topic: String, port: UInt16) {
        self.username = username
        self.password = password
        self.token = token
        self.serverHost = serverHost
        self.topic = topic
        self.port = port
    }
}
