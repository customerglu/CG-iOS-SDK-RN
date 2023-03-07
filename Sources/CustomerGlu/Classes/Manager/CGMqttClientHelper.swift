//
//  CGMqttClientHelper.swift
//  
//
//  Created by Ankit Jain on 02/03/23.
//

import UIKit

// MARK: - CGMqttClientDelegate
protocol CGMqttClientDelegate: NSObjectProtocol {
    func getEntryPointByID(_ entryPointID: String)
}

//MARK: - CGMqttClientHelper
class CGMqttClientHelper: NSObject {
    static let shared = CGMqttClientHelper()
    
    private weak var delegate: CGMqttClientDelegate?
    private var client: LightMQTT?
    /**
     * MQTT Client can be setup using the following parameters -
     *
     * @param settings   - Pass all settings or configs requried for setting up Mqtt
     */
    func setupMQTTClient(withSettings settings: CGMqttSettings, delegate: CGMqttClientDelegate) {
        self.delegate = delegate
        
        DispatchQueue.main.async {
            var options = LightMQTT.Options()
            options.allowUntrustCACertificate = true
            options.useTLS = false
            options.securityLevel = .none
            options.networkServiceType = .background
            options.username = settings.username
            options.password = settings.password
            options.clientId = settings.mqttIdentifier
            options.pingInterval = 30
            options.bufferSize = 4096
            options.readQosClass = .background

            self.client = LightMQTT(host: settings.serverHost, options: options)
            guard let client = self.client else { return }
            
            client.connect() { success in
                if success {
                    print("*** Successfully Connected ***")
                    
                    // use the client to subscribe to topics here
                    self.subscribeToTopic(topic: settings.topic)
                } else {
                    print("*** Failed to Connect ***")
                }
            }
            
            client.receivingBuffer = { (topic: String, buffer: UnsafeBufferPointer<UTF8.CodeUnit>) in
                // parse buffer to JSON here
                
                DispatchQueue.main.async {
                    print("*** receivingBuffer :: \(topic) ***")
                }
            }
            
            client.receivingMessage = { (topic: String, message: String) in
                // parse buffer to JSON here
                
                DispatchQueue.main.async {
                    print("*** receivingMessage :: \(topic) :: \(message) ***")
                    let jsonString = message.fromBase64() ?? "EMPTY"
                    print("*** decodedString :: \(topic) :: \(jsonString) ***")
                    
                    let jsonData = Data(jsonString.utf8)
                    let decoder = JSONDecoder()
                    do {
                        if(jsonData.count > 0) {
                            let model = try decoder.decode(CGMqttMessage.self, from: jsonData)
                            if let delegate = self.delegate, let entryPointID = model.id {
                                delegate.getEntryPointByID(entryPointID)
                            }
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            
            client.receivingBytes = { (topic: String, _) in
                // parse buffer to JSON here
                
                DispatchQueue.main.async {
                    print("*** receivingBytes :: \(topic) ***")
                }
            }
            
            client.receivingData = { (topic: String, _) in
                // parse buffer to JSON here
                
                DispatchQueue.main.async {
                    print("*** receivingData :: \(topic) ***")
                }
            }
        }
    }
    
    /**
     * Subscription topic should be shared
     *
     * @param topic
     */
    func subscribeToTopic(topic: String) {
        guard let client = client else { return }
        client.subscribe(to: topic)
    }
}
