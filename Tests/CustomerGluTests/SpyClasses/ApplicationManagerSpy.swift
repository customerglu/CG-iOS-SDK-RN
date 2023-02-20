//
//  File.swift
//  
//
//  Created by Ankit Jain on 20/02/23.
//

import Foundation
@testable import CustomerGlu

// MARK: - CGEventsDiagnosticsHelperSpy
class ApplicationManagerSpy: ApplicationManager {
    var apiCalled: Bool = false
    private var parent: ApplicationManager?
    
    init(parent: ApplicationManager) {
        super.init()
        apiCalled = false
        self.parent = parent
        
        APIManager.crashReport(queryParameters: NSDictionary()) { result in
            print("result")
        }
    }
    
    func testMyCode() {
        
    }
    
}
