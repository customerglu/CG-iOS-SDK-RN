//
//  File.swift
//  
//
//  Created by Kausthubh adhikari on 13/02/23.
//

import Foundation

class CGEventsDiagnosticsHelper {
   static let instance = CGEventsDiagnosticsHelper()
    
    
    func sendDiagnosticsReport(eventName: String, eventType: String, eventMeta:[String:Any]){
        if CustomerGlu.isDebugingEnabled {
            
            ApplicationManager.sendEventsDiagnostics(eventLogType: eventType, eventName: eventName, eventMeta: eventMeta, completion: { [self] success, diagnosticsEventResponse in
                if success {
                    
                }else {
                    
                }
            })
            
        }
    }
    
    
    
    
    
}
