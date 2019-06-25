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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    func setupButton() {
        view.layoutIfNeeded()
        signInButton.setCornerRadius()
        signInButton.setGradientBackground(colorOne: CustomColors.blue, colorTwo: CustomColors.green)
        signInButton.setStandardShadow()
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        authenticateWithBiometrics()
    }
    
    
    func authenticateWithBiometrics() {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, err) in
                if success {
                    self.performSegue(withIdentifier: "employeeSegue", sender: nil)
                    print("Successfully Authenticated User.")
                } else if let err = err {
                    print("Error: \(err)")
                }
            }
        } else {
            // no biometry so use username + password.
        }
    }
    

}

