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
    static let shared = CGMqttClientHelper()

    private var client: CocoaMQTT?
    
    /**
     * MQTT Client can be setup using the following parameters -
     *
     * @param username   - User name in CG SDK
     * @param token      - JWT token shared in Registration call
     * @param serverHost - MQTT broker server url
     * @param topic      - Topic to subscribe
     */
    public func setupMQTTClient(withSettings settings: CGMqttSettings) {
        DispatchQueue.main.async {
            let clientID = UUID().uuidString
            self.client = CocoaMQTT(clientID: clientID, host: settings.serverHost, port: settings.port)
            guard let client = self.client else { return }
            
            client.username = settings.username
            client.password = settings.password
            client.autoReconnect = true
            client.autoReconnectTimeInterval = 60
            client.keepAlive = 60
//            client.enableSSL = true
//            client.allowUntrustCACertificate = true
            client.logLevel = .debug
            
            client.didConnectAck = { mqtt, ack in
                print("Did Connect Acknowledge \(ack.description)")
            }
            
            client.didPublishMessage = { mqtt, message, _ in
                print("Did Publish Message \(message.topic) with payload \(message.string ?? "")")
            }
            
            // And Listen for Message
            client.didReceiveMessage = { mqtt, message, id in
                print("Message received in topic \(message.topic) with payload \(message.string ?? "")")
                
            }
            
            client.didSubscribeTopics = { mqtt, dict, arr in
                print("Did Subscribe to topic \(dict) \(arr)")
                
            }
            
            client.didChangeState = { mqtt, state in
                print("Did Change State \(state.description)")
            }
            
            // First Connect
            _ = client.connect()
            
            // Than Subscribe
            self.subscribeToTopic(topic: settings.topic)
            client.publish(settings.topic, withString: "CustomerGLU")
            client.ping()
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
