//
//  CGClientTestingViewModel.swift
//  
//
//  Created by Ankit Jain on 22/02/23.
//

import UIKit

// MARK: - CGClientTestingStatus
public enum CGClientTestingStatus: Int {
    case pending
    case success
    case failure
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
    func updateTable(atIndexPath indexPath: IndexPath)
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
    
    private func getIndexOfItem(_ item: CGClientTestingRowItem) -> Int? {
        let firstIndex = eventsSectionsArray.firstIndex { event in
            event.getTitle() == item.getTitle()
        }
        return firstIndex
    }
    
    private func updateTableDelegate(atIndexPath indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.updateTable(atIndexPath: indexPath)
        }
    }
    
    // MARK: - Event Execution Methods
    func executeClientTesting() {
        // Execute SDKInitialised
        guard let index = getIndexOfItem(.sdkInitialised(status: .pending)) else { return }
        let indexPath = IndexPath(row: index, section: 0)
        
        if CustomerGlu.getInstance.appconfigdata != nil {
            eventsSectionsArray[index] = .sdkInitialised(status: .success)
            updateTableDelegate(atIndexPath: indexPath)
            
            // Execute next event
            executeUserRegistered()
        } else {
            eventsSectionsArray[index] = .sdkInitialised(status: .failure)
            updateTableDelegate(atIndexPath: indexPath)
        }
    }
    
    private func executeUserRegistered() {
        guard let index = getIndexOfItem(.userRegistered(status: .pending)) else { return }
        let indexPath = IndexPath(row: index, section: 0)
        
        if CustomerGlu.getInstance.cgUserData.userId != nil {
            eventsSectionsArray[index] = .userRegistered(status: .success)
            updateTableDelegate(atIndexPath: indexPath)
            
            // Execute next event
            executecallbackHanding()
        } else {
            eventsSectionsArray[index] = .userRegistered(status: .failure)
            updateTableDelegate(atIndexPath: indexPath)
        }
    }
    
    private func executecallbackHanding() {
        guard let index = getIndexOfItem(.callbackHanding(status: .pending)) else { return }
        let indexPath = IndexPath(row: index, section: 0)
        
        //TODO: Ankit Jain - Hard code callbackConfigurationUrl
        CustomerGlu.getInstance.appconfigdata?.callbackConfigurationUrl = "https://app1.cglu.us/u/2Jotac3J4kM55bsMX4gfV2KJnPD"
        
        if let callbackConfigurationUrl = CustomerGlu.getInstance.appconfigdata?.callbackConfigurationUrl, let deepurl = URL(string: callbackConfigurationUrl) {
            CustomerGlu.getInstance.openDeepLink(deepurl: deepurl) {[weak self]
                success, string, deeplinkdata in
                DispatchQueue.main.async {
                    if (success == .DEEPLINK_URL || success == .SUCCESS) && deeplinkdata != nil {
                        self?.eventsSectionsArray[index] = .callbackHanding(status: .success)
                        self?.updateTableDelegate(atIndexPath: indexPath)
                    } else {
                        self?.eventsSectionsArray[index] = .callbackHanding(status: .failure)
                        self?.updateTableDelegate(atIndexPath: indexPath)
                    }
                }
            }
        } else {
            eventsSectionsArray[index] = .callbackHanding(status: .failure)
            updateTableDelegate(atIndexPath: indexPath)
        }
    }
    
    private func executeNudgeHandling() {
        guard let index = getIndexOfItem(.nudgeHandling(status: .pending)) else { return }
        let indexPath = IndexPath(row: index, section: 0)

        eventsSectionsArray[index] = .nudgeHandling(status: .pending)
        updateTableDelegate(atIndexPath: indexPath)
    }
    
    private func executeOnelinkHandling() {
        guard let index = getIndexOfItem(.onelinkHandling(status: .pending)) else { return }
        let indexPath = IndexPath(row: index, section: 0)

        eventsSectionsArray[index] = .onelinkHandling(status: .pending)
        updateTableDelegate(atIndexPath: indexPath)
    }
    
    private func executeSendingEventsWorking() {
        guard let index = getIndexOfItem(.sendingEventsWorking(status: .pending)) else { return }
        let indexPath = IndexPath(row: index, section: 0)

        eventsSectionsArray[index] = .sendingEventsWorking(status: .pending)
        updateTableDelegate(atIndexPath: indexPath)
    }
    
    private func executeEntryPointSetup() {
        guard let index = getIndexOfItem(.entryPointSetup(status: .pending)) else { return }
        let indexPath = IndexPath(row: index, section: 0)

        eventsSectionsArray[index] = .entryPointSetup(status: .failure)
        updateTableDelegate(atIndexPath: indexPath)
    }
}
