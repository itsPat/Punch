//
//  LoginViewController.swift
//  Punch
//
//  Created by Patrick Trudel on 2019-06-24.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    var email = ""
    var password = ""
    var idCompany = ""
    var name = ""
  
  let authService = AuthService.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.view.setGradientBackground(colorOne: CustomColors.blue, colorTwo: CustomColors.darkBlue)
//        self.authService.registerUser(withEmail: "russell@punch.ca", andPassword: "test123") { (complete, error) in
//            print("complete")
//        }
//        if let credentials = authService.loadPasswordAndLoginInKeyChain(),
//            let email = credentials["email"],
//            let password = credentials["password"] {
//            self.userTextField.text = email
//            self.email = email
//            self.password = password
//        }
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        authService.loginUser(withEmail: email, andPassword: password) { (complete, error) in
            if let error = error {
                print("❌\(error.localizedDescription)❌")
                self.authenticateWithBiometrics()
                return
            } else if complete {
                self.authenticateWithBiometrics()
            }
        }
    }
  
  
    
    
    func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, err) in
                if success {
                    DispatchQueue.main.async {
                        print(credetial.isAdministrator ? "⭐️adminSegue⭐️" : "⭐️employeeSegue⭐️")
                        self.performSegue(withIdentifier: credetial.isAdministrator ? "adminSegue" : "employeeSegue", sender: nil)
                    }
                } else if let err = err {
                    print("Error: \(err)")
                }
            }
        } else {
            // no biometry so use username + password.
        }
    }
    
    override func viewDidLayoutSubviews() {
        signInButton.setCornerRadius()
        signInButton.setGradientBackground(colorOne: CustomColors.orange, colorTwo: CustomColors.darkOrange)
        signInButton.setStandardShadow()
        userTextField.setCornerRadius()
        passTextField.setCornerRadius()
    }
}




