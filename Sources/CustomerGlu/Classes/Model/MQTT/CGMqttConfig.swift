//
//  File.swift
//  
//
//  Created by Ankit Jain on 06/03/23.
//

import Foundation

struct CGMqttConfig {
    var username: String!
    var password: String!
    var token: String!
    var serverHost: String!
    var topic: String!
    var port: UInt16!
    var mqttIdentifier: String!
    
    init(username: String, password: String, token: String, serverHost: String, topic: String, port: UInt16, mqttIdentifier: String) {
        self.username = username
        self.password = password
        self.token = token
        self.serverHost = serverHost
        self.topic = topic
        self.port = port
        self.mqttIdentifier = mqttIdentifier
    }
}
