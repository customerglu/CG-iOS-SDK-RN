//
//  File.swift
//  
//
//  Created by kapil on 10/11/21.
//

import Foundation

class OpenWalletViewModel {

    public func updateProfile(completion: @escaping (Bool, RegistrationModel?) -> Void) {
        let userData = [String: AnyHashable]()
        CustomerGlu.getInstance.updateProfile(userdata: userData) { success, registrationModel in
            if success {
                completion(true, registrationModel)
            } else {
                completion(false, nil)
                CustomerGlu.getInstance.printlog(cglog: "UpdateProfile API fail", isException: false, methodName: "OpenWalletViewModel-updateProfile", posttoserver: true)
            }
        }
    }
}
