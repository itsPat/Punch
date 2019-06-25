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

    let authService = AuthService.instance
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }
    
    func setupButton() {
        signInButton.setGradientBackground(colorOne: CustomColors.blue, colorTwo: CustomColors.green)
//        signInButton.setStandardShadow() Is affecting the size of the gradient.
        signInButton.layer.cornerRadius = signInButton.bounds.height*0.1
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        authService.authenticateWithBiometrics { (status, error) in
            if status {
                self.performSegue(withIdentifier: "employeeSegue", sender: nil)
                print("Successfully Authenticated User.")
            } else {
                print("Error: \(String(describing: error)) - \(#file) - \(#function) - \(#line)")
            }
        }
    }
    
    
   
    

}

