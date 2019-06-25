//
//  AuthService.swift
//  Punch
//
//  Created by Luiz on 6/25/19.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import Foundation
import LocalAuthentication
import Firebase
class AuthService {

    static let instance = AuthService()

    func authenticateWithBiometrics(authenticated: @escaping(_ status: Bool, _ error: Error?) -> ()) {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, err) in
                if success {
                    authenticated(true, nil)
                    print("Successfully Authenticated User.")
                } else if let err = err {
                    authenticated(false, err)
                }
            }
        } else {
            // no biometry so use username + password.
            authenticated(false, error)
        }
    }

//    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
//        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//            guard let user = user else {
//                userCreationComplete(false, error)
//                return
//            }
//
//            let userData = ["provider": user.providerID, "email": user.email]
//            DataService.instance.createDBUser(uid: user.uid, userData: userData)
//            userCreationComplete(true, nil)
//        }
//    }
//
//    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
//        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
//            if error != nil {
//                loginComplete(false, error)
//                return
//            }
//            loginComplete(true, nil)
//        }
//    }
}
