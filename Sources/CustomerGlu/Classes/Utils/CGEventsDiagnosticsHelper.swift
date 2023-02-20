//
//  File.swift
//  
//
//  Created by Kausthubh adhikari on 13/02/23.
//

import Foundation

public class CGEventsDiagnosticsHelper {
   static let shared = CGEventsDiagnosticsHelper()
    
    /***
        Sending DIagnostics events 
     
     */
    func sendDiagnosticsReport(eventName: String, eventType: String, eventMeta:[String:Any]) {
        let logParameters: [String: Any] = ["eventName": eventName,
                                            "eventType": eventType,
                                            "eventMeta": eventMeta]
        let source = CGLoggingSource(sourceClass: CGLogUtility.classNameAsString(self), sourceMethod: "sendDiagnosticsReport")
        
        if eventType == CGDiagnosticConstants.CG_TYPE_DIAGNOSTICS && !(CustomerGlu.isDiagnosticsEnabled ?? false) {
            // Below logs will be used in testing
            if CGLoggingMessage.shared.isRunningTests() {
                CGLoggingMessage.shared.logMessage(eventType: .serviceCall, source: source, logMessage: CGLoggingConstant.failure, parameters: logParameters)
            }

            return
        }
        
        if eventType == CGDiagnosticConstants.CG_TYPE_METRICS && !(CustomerGlu.isMetricsEnabled ?? true) {
            // Below logs will be used in testing
            if CGLoggingMessage.shared.isRunningTests() {
                CGLoggingMessage.shared.logMessage(eventType: .serviceCall, source: source, logMessage: CGLoggingConstant.failure, parameters: logParameters)
            }
            
            return
        }
        
        if (eventType == CGDiagnosticConstants.CG_TYPE_CRASH || eventType == CGDiagnosticConstants.CG_TYPE_EXCEPTION) && !(CustomerGlu.isCrashLogsEnabled ?? true) {
            // Below logs will be used in testing
            if CGLoggingMessage.shared.isRunningTests() {
                CGLoggingMessage.shared.logMessage(eventType: .serviceCall, source: source, logMessage: CGLoggingConstant.failure, parameters: logParameters)
            }
            return
        }
        
        if let sdkIsDisabled = CustomerGlu.sdk_disable, !sdkIsDisabled {
            // Below logs will be used in testing
            if CGLoggingMessage.shared.isRunningTests() {
                CGLoggingMessage.shared.logMessage(eventType: .serviceCall, source: source, logMessage: CGLoggingConstant.success, parameters: logParameters)
            }
            
            ApplicationManager.sendEventsDiagnostics(eventLogType: eventType, eventName: eventName, eventMeta: eventMeta, completion: { success, diagnosticsEventResponse in
                if success {
                    print(eventName+" SuccessFully sent")
                } else {
                    print(eventName+" Failure in sending")
                }
            })
        }
    }
}
