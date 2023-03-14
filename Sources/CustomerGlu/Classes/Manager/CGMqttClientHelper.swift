//
//  CGMqttClientHelper.swift
//  
//
//  Created by Ankit Jain on 02/03/23.
//

import UIKit

// MARK: - CGMqttClientDelegate
protocol CGMqttClientDelegate: NSObjectProtocol {
    func getEntryPointDataWithMqttMessage(_ mqttMessage: CGMqttMessage)
}

//MARK: - CGMqttClientHelper
class CGMqttClientHelper: NSObject {
    static let shared = CGMqttClientHelper()
    
    private weak var delegate: CGMqttClientDelegate?
    private var client: LightMQTT?
    /**
     * MQTT Client can be setup using the following parameters -
     *
     * @param config   - Pass all config requried for setting up Mqtt
     */
    func setupMQTTClient(withConfig config: CGMqttConfig, delegate: CGMqttClientDelegate) {
        self.delegate = delegate
        
        DispatchQueue.main.async {
            var options = LightMQTT.Options()
            options.allowUntrustCACertificate = true
            options.useTLS = false
            options.securityLevel = .none
            options.networkServiceType = .background
            options.username = config.username
            options.password = config.password
            options.clientId = config.mqttIdentifier
            options.pingInterval = 30
            options.bufferSize = 4096
            options.readQosClass = .background

            self.client = LightMQTT(host: config.serverHost, options: options)
            guard let client = self.client else { return }
            
            client.connect() { success in
                if success {
                    // use the client to subscribe to topics here
                    self.subscribeToTopic(topic: config.topic)
                }
            }
            
            client.receivingMessage = { (topic: String, message: String) in
                // parse buffer to JSON here
                
                DispatchQueue.main.async {
                    let jsonString = message.fromBase64() ?? ""
                    let jsonData = Data(jsonString.utf8)
                    let decoder = JSONDecoder()
                    do {
                        if(jsonData.count > 0) {
                            let model = try decoder.decode(CGMqttMessage.self, from: jsonData)
                            if let delegate = self.delegate, let type = model.type, type.caseInsensitiveCompare("ENTRYPOINT") == .orderedSame {
                                delegate.getEntryPointDataWithMqttMessage(model)
                            }
                        }
                    } catch {
                        // Add Diagnostics
                        //print(error.localizedDescription)
                    }
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
