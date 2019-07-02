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

var credetial = Credential()
class AuthService {
    let keychainManager = KeychainManager()
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


                    //Check if the user is authenticated
                    if Auth.auth().currentUser == nil {

                        guard let authenticationDic = self.loadPasswordAndLoginInKeyChain() else {
                            //TODO: show aletar to user
                            print("Cannot unwrapper authenticationDic - \(#file) - \(#function) - \(#line)")
                            return
                        }
                        guard let keychainPassword = authenticationDic["password"] else {
                            print("Cannot unwrapper keychainPassword - \(#file) - \(#function) - \(#line)")
                            return
                        }

                        guard let keychainEmail = authenticationDic["email"] else {
                            print("Cannot unwrapper keychainEmail - \(#file) - \(#function) - \(#line)")
                            return
                        }
                        self.loginUser(withEmail: keychainEmail, andPassword: keychainPassword, loginComplete: { (success, error) in
                            if !success {
                                print("Cannot login in firebase - \(#file) - \(#function) - \(#line)")
                                //TODO: Show Alert
                            }
                        })

                        if credetial.isAdministrator {

                        }

                        //TODO: Authenticate the user in the Firebase
                        //TODO: Check if the guy is a manager
                        //TODO: download all information
                    }
                } else if let err = err {
                    //TODO: Authenticate the user with username + password
                    if Auth.auth().currentUser == nil {
                        guard let authenticationDic = self.loadPasswordAndLoginInKeyChain() else {
                            //TODO: show aletar to user
                            print("Cannot unwrapper authenticationDic - \(#file) - \(#function) - \(#line)")
                            return
                        }
                        guard let keychainPassword = authenticationDic["password"] else {
                            print("Cannot unwrapper keychainPassword - \(#file) - \(#function) - \(#line)")
                            return
                        }

                        guard let keychainEmail = authenticationDic["email"] else {
                            print("Cannot unwrapper keychainEmail - \(#file) - \(#function) - \(#line)")
                            return
                        }
                        self.loginUser(withEmail: keychainEmail, andPassword: keychainPassword, loginComplete: { (success, error) in
                            if !success {
                                print("Cannot login in firebase - \(#file) - \(#function) - \(#line)")
                                //TODO: Show Alert
                            }
                        })
                    }

                    authenticated(false, err)
                }
            }
        } else {
            // no biometry so use username + password.
            //TODO: Authenticate the use with username + password
            authenticated(false, error)
        }
    }

    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {

        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in

            //TODO: Implement the validation here
            //            if !(error is NSNull ){
            //                print("Error registering user \(error?.localizedDescription)  at \(#file) - \(#function) - \(#line)")
            //                if let erroCode = AuthErrorCode(rawValue: error!._code) {
            //                    print(erroCode)
            //                }
            //                return
            //            }

            guard let user = user else {
                userCreationComplete(false, error)

                return
            }

            DataService.instance.getEmployeeByEmail(forEmail: email, handler: { (employee) in
                let dic : [String: Any] = [
                    "id": employee.id,
                    "name" : employee.name,
                    "companyId" : employee.companyId,
                    "email" : employee.email,
                    "administratorId" : employee.administratorId ?? "",
                    "isAdministrator" : employee.isAdministrator ,
                    "hourlyRate" : employee.hourlyRate,
                ]

                DataService.instance.createDBUser(uid: user.user.uid, userData: dic as [String : Any])
                userCreationComplete(true, nil)
            })

        }
    }

    func savePasswordAndLoginInKeyChain(password: String, email: String )  {
        do {
            try keychainManager.set(string: password, forKey: "password")
            try keychainManager.set(string: email, forKey: "email")
        } catch {
            print("Error saving in keychain - error: \(error.localizedDescription) -\(#file) - \(#function) - \(#line)")
        }

    }

    func loadPasswordAndLoginInKeyChain() -> [String: String]?{
        do {
            guard let password = try keychainManager.loadValue(forKey: "password") else {
                print("Error loading password in keychain -\(#file) - \(#function) - \(#line)")
                return nil
            }
            guard let email = try keychainManager.loadValue(forKey: "email") else {
                print("Error loading email in keychain -\(#file) - \(#function) - \(#line)")
                return nil
            }
            return ["password" : password, "email": email]
        } catch  {
            print("Error loading in keychain -\(#file) - \(#function) - \(#line)")
        }
        return nil
    }


    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false, error)
                return
            }

            guard let uid = user?.user.uid else {
                return
            }

            DataService.instance.getUserByUID(foruid: uid, AndPassword: password, handler: { (user) in
                credetial = user
                loginComplete(true, nil)

            })

            //Write this line in AuthService - to save the password and login in keychain
            self.savePasswordAndLoginInKeyChain(password: password, email: email)
        }
    }
}
