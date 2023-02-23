//
//  CGClientTestingPresenter.swift
//  
//
//  Created by Ankit Jain on 22/02/23.
//

import UIKit

// MARK: - CGClientTestingRowItem
public enum CGClientTestingRowItem: String {
    case sdkInitialised = "SDK Initialised"
    case userRegistered = "User Registered"
    case callbackHanding = "Callback Handing"
    case nudgeHandling = "Nudge Handling"
    case onelinkHandling = "Onelink Handling"
    case sendingEventsWorking = "Sending Events Working"
    case entryPointSetup = "Entry Point Setup"
    case sendNudge = "Send Nudge"
    case sendEvent = "Send Event"
    case triggerCallback = "Trigger Callback"
}

// MARK: - CGClientTestingPresenter
public class CGClientTestingPresenter: NSObject {

    var eventsSectionsArray: [CGClientTestingRowItem] = [.sdkInitialised, .userRegistered, .callbackHanding, .nudgeHandling, .onelinkHandling, .sendingEventsWorking, .entryPointSetup]
    var actionsSectionArray: [CGClientTestingRowItem] = [.sendNudge, .sendEvent, .triggerCallback]
    
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
}
