//
//  CGMqttClientHelper.swift
//  
//
//  Created by Ankit Jain on 02/03/23.
//

import UIKit
import CocoaMQTT
import MqttCocoaAsyncSocket

//MARK: - CGMqttClientHelper
public class CGMqttClientHelper: NSObject {
    private var client: CocoaMQTT?
    
    /**
     * MQTT Client can be setup using the following parameters -
     *
     * @param username   - User name in CG SDK
     * @param token      - JWT token shared in Registration call
     * @param serverHost - MQTT broker server url
     * @param topic      - Topic to subscribe
     */
    public func setupMQTTClient(username: String, token: String, serverHost: String, topic: String) {
        
        let clientID = UUID().uuidString
        client = CocoaMQTT(clientID: clientID, host: serverHost, port: 18925)
        guard let client = client else { return }

        client.username = "j5uG9wdvO1cekcMb7XugpUBwaXn1"
        client.password = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJqNXVHOXdkdk8xY2VrY01iN1h1Z3BVQndhWG4xIiwiZ2x1SWQiOiI1MjgwOTQ3Ni1hMDcyLTQwMTQtYTQ2YS0yZjNjZjU5ZmQ3NTQiLCJjbGllbnQiOiJhYjQ1YzA3YS0wZDljLTRjMjMtYTNiMC1hMTY3NThkOWJjM2IiLCJkZXZpY2VJZCI6Imo1dUc5d2R2TzFjZWtjTWI3WHVncFVCd2FYbjFfZGVmYXVsdCIsImRldmljZVR5cGUiOiJkZWZhdWx0IiwiaXNMb2dnZWRJbiI6dHJ1ZSwiaWF0IjoxNjc3NTczOTQxLCJleHAiOjE3MDkxMDk5NDF9.5DBKxfV6lnVSXnNyy-U_OZ5olRbCE0od8PXvRj9-qKQ"
        client.autoReconnect = true
        client.autoReconnectTimeInterval = 60
        client.keepAlive = 60
        
        // First Connect
        _ = client.connect()

        // Than Subscribe
        subscribeToTopic(topic: topic)

        // And Listen for Message
        client.didReceiveMessage = { mqtt, message, id in
            print("Message received in topic \(message.topic) with payload \(message.string ?? "")")
            
        }
    }
    
    /**
     * Subscription topic should be shared
     *
     * @param topic
     */
    public func subscribeToTopic(topic: String) {
        guard let client = client else { return }
        // CocoaMQTTQoS.qos1 == At least once delivery
        client.subscribe(topic, qos: .qos1)
    }
}
