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
    case pending
    case success
    case failure
    case retry
}

// MARK: - CGClientTestingRowItem
public enum CGClientTestingRowItem {
    case sdkInitialised(status: CGClientTestingStatus)
    case userRegistered(status: CGClientTestingStatus)
    case callbackHanding(status: CGClientTestingStatus)
    case nudgeHandling(status: CGClientTestingStatus)
    case onelinkHandling(status: CGClientTestingStatus)
    case sendingEventsWorking(status: CGClientTestingStatus)
    case entryPointSetup(status: CGClientTestingStatus)
    case sendNudge
    case sendEvent
    case triggerCallback
    
    func getTitle() -> String {
        switch self {
        case .sdkInitialised:
            return "SDK Initialised"
        case .userRegistered:
            return "User Registered"
        case .callbackHanding:
            return "Callback Handing"
        case .nudgeHandling:
            return "Nudge Handling"
        case .onelinkHandling:
            return "Onelink Handling"
        case .sendingEventsWorking:
            return "Sending Events Working"
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
        case .sdkInitialised(let status):
            return status
        case .userRegistered(let status):
            return status
        case .callbackHanding(let status):
            return status
        case .nudgeHandling(let status):
            return status
        case .onelinkHandling(let status):
            return status
        case .sendingEventsWorking(let status):
            return status
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
}

// MARK: - CGClientTestingProtocol
public protocol CGClientTestingProtocol: NSObjectProtocol {
    func updateTable(atIndexPath indexPath: IndexPath, forEvent event: CGClientTestingRowItem)
    func showCallBackAlert()
}

// MARK: - CGClientTestingViewModel
public class CGClientTestingViewModel: NSObject {
    
    weak var delegate: CGClientTestingProtocol?
    var eventsSectionsArray: [CGClientTestingRowItem] = [.sdkInitialised(status: .pending), .userRegistered(status: .pending), .callbackHanding(status: .pending), .nudgeHandling(status: .pending), .onelinkHandling(status: .pending), .sendingEventsWorking(status: .pending), .entryPointSetup(status: .pending)]
    var actionsSectionArray: [CGClientTestingRowItem] = [.sendNudge]
    
    func numberOfSections() -> Int {
        2
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
    
    @objc private func showCallBackAlert() {
        if let delegate = delegate {
            delegate.showCallBackAlert()
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
    
    private func executeUserRegistered() {
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
    
    private func executecallbackHanding() {
        let itemInfo = getIndexOfItem(.callbackHanding(status: .pending))
        guard let index = itemInfo.index, let indexPath = itemInfo.indexPath else { return }
                        
        let webController = CustomerWebViewController()
        let message: WKScriptMessage = WKScriptMessage()

        //TODO: Ankit Jain - Below is hard coded body data
        let eventLinkData = CGEventLinkData(deepLink: "/shop")
        let model = CGDeepLinkModel(eventName: "OPEN_DEEPLINK", data: eventLinkData)
        
        do {
            let jsonData = try JSONEncoder().encode(model)

            webController.handleDeeplinkEvent(withEventName: WebViewsKey.open_deeplink, bodyData: jsonData, message: message)

            // just show alert - Yes show green tick - No show cross UI
            // Add retry button next to call back, nudge and onelink
            // Retry only for NETWORK_EXCEPTION
            
            eventsSectionsArray[index] = .callbackHanding(status: .pending)
            updateTableDelegate(atIndexPath: indexPath, forEvent: eventsSectionsArray[index])

            // Wait 5 seconds and than perform this action
            perform(#selector(showCallBackAlert), with: nil, afterDelay: 5.0)
            
            // Parallel execute next steps
            executeNudgeHandling()
        } catch {
            // nothing
        }
    }
    
    private func executeNudgeHandling() {
        let itemInfo = getIndexOfItem(.nudgeHandling(status: .pending))
        guard let index = itemInfo.index, let indexPath = itemInfo.indexPath else { return }

        var queryParameters: [String: Any] = [:]
        queryParameters[APIParameterKey.userId] = "glutest-4321"
        queryParameters["flag"] = "staging"
        queryParameters["client"] = "84acf2ac-b2e0-4927-8653-cba2b83816c2"
        
        APIManager.nudgeIntegration(queryParameters: queryParameters as NSDictionary) {[weak self] result in
            switch result {
            case .success(_):
                let event: CGClientTestingRowItem = .nudgeHandling(status: .success)
                self?.eventsSectionsArray[index] = event
                self?.updateTableDelegate(atIndexPath: indexPath, forEvent: event)
                
            case .failure(_):
                let event: CGClientTestingRowItem = .nudgeHandling(status: .retry)
                self?.eventsSectionsArray[index] = event
                self?.updateTableDelegate(atIndexPath: indexPath, forEvent: event)
            }
        }
        
        // Parallel execute next steps
        executeOnelinkHandling()
    }
    
    @objc private func executeOnelinkHandling() {
        let itemInfo = getIndexOfItem(.onelinkHandling(status: .pending))
        guard let index = itemInfo.index, let indexPath = itemInfo.indexPath else { return }

        //TODO: Ankit Jain - Hard code callbackConfigurationUrl
        CustomerGlu.getInstance.appconfigdata?.callbackConfigurationUrl = "https://app1.cglu.us/u/2Jotac3J4kM55bsMX4gfV2KJnPD"
        
        if let callbackConfigurationUrl = CustomerGlu.getInstance.appconfigdata?.callbackConfigurationUrl, let deepurl = URL(string: callbackConfigurationUrl) {
            CustomerGlu.getInstance.openDeepLink(deepurl: deepurl) {[weak self]
                success, string, deeplinkdata in
                DispatchQueue.main.async {
                    if (success == .DEEPLINK_URL || success == .SUCCESS) && deeplinkdata != nil {
                        self?.eventsSectionsArray[index] = .onelinkHandling(status: .success)
                        self?.updateTableDelegate(atIndexPath: indexPath, forEvent: .onelinkHandling(status: .success))
                    } else {
                        self?.eventsSectionsArray[index] = .onelinkHandling(status: .failure)
                        self?.updateTableDelegate(atIndexPath: indexPath, forEvent: .onelinkHandling(status: .failure))
                    }
                }
            }
        } else {
            eventsSectionsArray[index] = .onelinkHandling(status: .failure)
            updateTableDelegate(atIndexPath: indexPath, forEvent: eventsSectionsArray[index])
        }
        
        // Parallel execute next steps
        executeSendingEventsWorking()
    }
    
    private func executeSendingEventsWorking() {
        let itemInfo = getIndexOfItem(.sendingEventsWorking(status: .pending))
        guard let index = itemInfo.index, let indexPath = itemInfo.indexPath else { return }

        eventsSectionsArray[index] = .sendingEventsWorking(status: .pending)
        updateTableDelegate(atIndexPath: indexPath, forEvent: eventsSectionsArray[index])
        
        // Parallel execute next steps
        executeEntryPointSetup()
    }
    
    private func executeEntryPointSetup() {
        let itemInfo = getIndexOfItem(.entryPointSetup(status: .pending))
        guard let index = itemInfo.index, let indexPath = itemInfo.indexPath else { return }

        eventsSectionsArray[index] = .entryPointSetup(status: .failure)
        updateTableDelegate(atIndexPath: indexPath, forEvent: eventsSectionsArray[index])
    }
}
