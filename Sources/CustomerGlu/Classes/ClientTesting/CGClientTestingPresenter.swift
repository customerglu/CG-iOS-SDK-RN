//
//  CGClientTestingViewModel.swift
//  
//
//  Created by Ankit Jain on 22/02/23.
//

import UIKit
import WebKit

// MARK: - CGClientTestingStatus
public enum CGClientTestingStatus: Int {
    case header
    case pending
    case success
    case failure
}

// MARK: - CGCustomAlertTag
public enum CGCustomAlertTag: Int {
    case callbackHandingTag = 1001
    case nudgeHandlingTag = 1002
    case onelinkHandlingTag = 1003
}

// MARK: - CGClientTestingRowItem
public enum CGClientTestingRowItem {
    case basicIntegration(status: CGClientTestingStatus)
    case sdkInitialised(status: CGClientTestingStatus)
    case userRegistered(status: CGClientTestingStatus)
    case callbackHanding(status: CGClientTestingStatus)
    case advanceIntegration(status: CGClientTestingStatus)
    case nudgeHandling(status: CGClientTestingStatus)
    case onelinkHandling(status: CGClientTestingStatus)
    //case sendingEventsWorking(status: CGClientTestingStatus)
    case entryPointSetup(status: CGClientTestingStatus)
    case sendNudge
    case sendEvent
    case triggerCallback
    
    func getTitle() -> String {
        switch self {
        case .basicIntegration:
            return "Basic Integration"
        case .sdkInitialised:
            return "SDK Initialised"
        case .userRegistered:
            return "User Registered"
        case .callbackHanding:
            return "Callback Handing"
        case .advanceIntegration:
            return "Advance Integration"
        case .nudgeHandling:
            return "Nudge Handling"
        case .onelinkHandling:
            return "Onelink Handling"
//        case .sendingEventsWorking:
//            return "Sending Events Working"
        case .entryPointSetup:
            return "Entry Point Setup"
        case .sendNudge:
            return "Send Nudge"
        case .sendEvent:
            return "Send Event"
        case .triggerCallback:
            return "Trigger Callback"
        }
    }
    
    func getStatus() -> CGClientTestingStatus {
        switch self {
        case .basicIntegration(let status):
            return status
        case .sdkInitialised(let status):
            return status
        case .userRegistered(let status):
            return status
        case .callbackHanding(let status):
            return status
        case .advanceIntegration(let status):
            return status
        case .nudgeHandling(let status):
            return status
        case .onelinkHandling(let status):
            return status
//        case .sendingEventsWorking(let status):
//            return status
        case .entryPointSetup(let status):
            return status
        case .sendNudge:
            return .pending
        case .sendEvent:
            return .pending
        case .triggerCallback:
            return .pending
        }
    }
    
    func getAlertTitleAndMessage() -> (title: String, message: String, tag: Int)? {
        switch self {
        case .basicIntegration:
            return nil
        case .sdkInitialised:
            return nil
        case .userRegistered:
            return nil
        case .callbackHanding:
            return ("CustomerGlu", "Do you receive callback?", CGCustomAlertTag.callbackHandingTag.rawValue)
        case .advanceIntegration:
            return nil
        case .nudgeHandling:
            return ("CustomerGlu", "Do you see a nudge?", CGCustomAlertTag.nudgeHandlingTag.rawValue)
        case .onelinkHandling:
            return ("CustomerGlu", "Has CG Deeplink successfully redirected?", CGCustomAlertTag.onelinkHandlingTag.rawValue)
//        case .sendingEventsWorking:
//            return "Sending Events Working"
        case .entryPointSetup:
            return nil
        case .sendNudge:
            return nil
        case .sendEvent:
            return nil
        case .triggerCallback:
            return nil
        }
    }
}

// MARK: - CGClientTestingProtocol
public protocol CGClientTestingProtocol: NSObjectProtocol {
    func updateTable(atIndexPath indexPath: IndexPath, forEvent event: CGClientTestingRowItem)
    func showCallBackAlert(forEvent event: CGClientTestingRowItem, isRetry: Bool)
    func testOneLinkDeeplink(withDeeplinkURL deeplinkURL: String)
}

// MARK: - CGClientTestingViewModel
public class CGClientTestingViewModel: NSObject {
    
    weak var delegate: CGClientTestingProtocol?
    var eventsSectionsArray: [CGClientTestingRowItem] = [.basicIntegration(status: .header), .sdkInitialised(status: .pending), .userRegistered(status: .pending), .callbackHanding(status: .pending), .advanceIntegration(status: .header), .nudgeHandling(status: .pending), .onelinkHandling(status: .pending), .entryPointSetup(status: .pending)]
    var actionsSectionArray: [CGClientTestingRowItem] = [.sendNudge]
    
    func numberOfSections() -> Int {
        1
    }
    
    func numberOfCells(forSection section: Int) -> Int {
        switch section {
        case 0:
            return eventsSectionsArray.count
        case 1:
            return actionsSectionArray.count
        default:
            return 0
        }
    }
    
    func getRowItemForEventsSection(withIndexPath indexPath: IndexPath) -> CGClientTestingRowItem {
        eventsSectionsArray[indexPath.row]
    }
    
    func getRowItemForActionsSection(withIndexPath indexPath: IndexPath) -> CGClientTestingRowItem {
        actionsSectionArray[indexPath.row]
    }
    
    func getIndexOfItem(_ item: CGClientTestingRowItem) -> (index: Int?, indexPath: IndexPath?) {
        let firstIndex = eventsSectionsArray.firstIndex { event in
            event.getTitle() == item.getTitle()
        }
        
        var indexPath: IndexPath?
        if let index = firstIndex {
            indexPath = IndexPath(row: index, section: 0)
        }
        
        return (firstIndex, indexPath)
    }
    
    private func updateTableDelegate(atIndexPath indexPath: IndexPath, forEvent event: CGClientTestingRowItem) {
        if let delegate = delegate {
            delegate.updateTable(atIndexPath: indexPath, forEvent: event)
        }
    }
    
    private func showCallBackAlert(forEvent event: CGClientTestingRowItem, isRetry: Bool) {
        // Wait 5 seconds and than perform this action
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if let delegate = self.delegate {
                delegate.showCallBackAlert(forEvent: event, isRetry: isRetry)
            }
        }
    }
        
    // MARK: - Event Execution Methods
    func executeClientTesting() {
        // Execute SDKInitialised
        let itemInfo = getIndexOfItem(.sdkInitialised(status: .pending))
        guard let index = itemInfo.index, let indexPath = itemInfo.indexPath else { return }

        if CustomerGlu.getInstance.appconfigdata != nil {
            eventsSectionsArray[index] = .sdkInitialised(status: .success)
            updateTableDelegate(atIndexPath: indexPath, forEvent: eventsSectionsArray[index])
            
            // Execute next event
            executeUserRegistered()
        } else {
            eventsSectionsArray[index] = .sdkInitialised(status: .failure)
            updateTableDelegate(atIndexPath: indexPath, forEvent: eventsSectionsArray[index])
        }
    }
    
    func executeUserRegistered() {
        let itemInfo = getIndexOfItem(.userRegistered(status: .pending))
        guard let index = itemInfo.index, let indexPath = itemInfo.indexPath else { return }
        
        if CustomerGlu.getInstance.cgUserData.userId != nil {
            eventsSectionsArray[index] = .userRegistered(status: .success)
            updateTableDelegate(atIndexPath: indexPath, forEvent: eventsSectionsArray[index])

            // Execute all event
            executecallbackHanding()
        } else {
            eventsSectionsArray[index] = .userRegistered(status: .failure)
            updateTableDelegate(atIndexPath: indexPath, forEvent: eventsSectionsArray[index])
        }
    }
    
    func executecallbackHanding(isRetry: Bool = false) {
        let itemInfo = getIndexOfItem(.callbackHanding(status: .pending))
        guard let index = itemInfo.index, let indexPath = itemInfo.indexPath else { return }
                        
        let webController = CustomerWebViewController()
        let message: WKScriptMessage = WKScriptMessage()
        
        if let callbackConfigurationUrl = CustomerGlu.getInstance.appconfigdata?.callbackConfigurationUrl {
            let eventLinkData = CGEventLinkData(deepLink: callbackConfigurationUrl)
            let model = CGDeepLinkModel(eventName: "OPEN_DEEPLINK", data: eventLinkData)
            
            do {
                let jsonData = try JSONEncoder().encode(model)

                var diagnosticsEventData: [String: Any] = [:]
                webController.handleDeeplinkEvent(withEventName: WebViewsKey.open_deeplink, bodyData: jsonData, message: message, diagnosticsEventData: &diagnosticsEventData)

                // just show alert - Yes show green tick - No show cross UI
                // Add retry button next to call back, nudge and onelink
                // Retry only for NETWORK_EXCEPTION
                
                eventsSectionsArray[index] = .callbackHanding(status: .pending)
                updateTableDelegate(atIndexPath: indexPath, forEvent: eventsSectionsArray[index])

                // Wait 5 seconds and than perform this action & Next step NudgeHandling will happen on alert response Yes or No
                self.showCallBackAlert(forEvent: eventsSectionsArray[index], isRetry: isRetry)
            } catch {
                // nothing
            }
        }
    }
    
    func executeNudgeHandling(isRetry: Bool = false) {
        let itemInfo = getIndexOfItem(.nudgeHandling(status: .pending))
        guard let index = itemInfo.index, let indexPath = itemInfo.indexPath else { return }

        var queryParameters: [String: Any] = [:]
        queryParameters[APIParameterKey.userId] = CustomerGlu.getInstance.cgUserData.userId
        if CustomerGlu.fcm_apn != "fcm" {
            queryParameters["flag"] = "staging"
        }
        
        APIManager.nudgeIntegration(queryParameters: queryParameters as NSDictionary) {[weak self] result in
            switch result {
            case .success(_):
                let event: CGClientTestingRowItem = .nudgeHandling(status: .pending)
                // Wait 5 seconds and than perform this action
                self?.showCallBackAlert(forEvent: event, isRetry: isRetry)
            case .failure(_):
                let event: CGClientTestingRowItem = .nudgeHandling(status: .failure)
                self?.eventsSectionsArray[index] = event
                self?.updateTableDelegate(atIndexPath: indexPath, forEvent: event)
                
                // Execute next steps
                self?.executeOnelinkHandling()
            }
        }
    }
    
    @objc func executeOnelinkHandling(isRetry: Bool = false) {
        let itemInfo = getIndexOfItem(.onelinkHandling(status: .pending))
        guard let index = itemInfo.index, let indexPath = itemInfo.indexPath else { return }
        
        if let callbackConfigurationUrl = CustomerGlu.getInstance.appconfigdata?.callbackConfigurationUrl {
            if let delegate = self.delegate {
                delegate.testOneLinkDeeplink(withDeeplinkURL: callbackConfigurationUrl)
            }

            // Wait 5 seconds and than perform this action
            self.showCallBackAlert(forEvent: .onelinkHandling(status: .pending), isRetry: isRetry)
            
//            CustomerGlu.getInstance.openDeepLink(deepurl: deepurl) {[weak self]
//                success, string, deeplinkdata in
//
//                DispatchQueue.main.async {
//                    if (success == .DEEPLINK_URL || success == .SUCCESS) && deeplinkdata != nil {
//                        self?.eventsSectionsArray[index] = .onelinkHandling(status: .success)
//                        self?.updateTableDelegate(atIndexPath: indexPath, forEvent: .onelinkHandling(status: .success))
//                    } else {
//                        self?.eventsSectionsArray[index] = .onelinkHandling(status: .failure)
//                        self?.updateTableDelegate(atIndexPath: indexPath, forEvent: .onelinkHandling(status: .failure))
//                    }
//
//                    // Execute next steps
//                    self?.executeEntryPointSetup()
//                }
//            }
        } else {
            eventsSectionsArray[index] = .onelinkHandling(status: .failure)
            updateTableDelegate(atIndexPath: indexPath, forEvent: eventsSectionsArray[index])
            
            // Execute next steps
            executeEntryPointSetup()
        }
    }
    
//    private func executeSendingEventsWorking() {
//        let itemInfo = getIndexOfItem(.sendingEventsWorking(status: .pending))
//        guard let index = itemInfo.index, let indexPath = itemInfo.indexPath else { return }
//
//        eventsSectionsArray[index] = .sendingEventsWorking(status: .pending)
//        updateTableDelegate(atIndexPath: indexPath, forEvent: eventsSectionsArray[index])
//
//        // Parallel execute next steps
//        executeEntryPointSetup()
//    }
    
    func executeEntryPointSetup() {
        let itemInfo = getIndexOfItem(.entryPointSetup(status: .pending))
        guard let index = itemInfo.index, let indexPath = itemInfo.indexPath else { return }

        eventsSectionsArray[index] = .entryPointSetup(status: .success)
        updateTableDelegate(atIndexPath: indexPath, forEvent: eventsSectionsArray[index])
    }
}
