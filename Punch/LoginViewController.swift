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

    var idCompany = "6EB8AAAF-576E-4B1F-8B02-742E0C6141F0"
    var name = ""

    let authService = AuthService.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.view.setGradientBackground(colorOne: CustomColors.darkBlue, colorTwo: CustomColors.blue)
//        test3()
//        test4()
        print(credetial)

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
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "employeeSegue", sender: nil)
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
    }
}




extension LoginViewController {

    func test() {
        let dataService = DataService.instance
        dataService.getEmployeesByCompanyId(companyId: "6EB8AAAF-576E-4B1F-8B02-742E0C6141F0") { (employees) in
            print(employees)
        }
    }

    func test2() {
        let dataService = DataService.instance
        //              dataService.createDBCompany(uid: UUID().uuidString, companyData: ["name": "Microsoft"])
        dataService.getCompanyId(forCompany: "Microsoft") { (id) in
            print(id)
            self.idCompany = id
            let employee = Employee1(id: UUID().uuidString,
                                     name: "Woz",
                                     email: "Woz@microsoft.com",
                                     companyId: self.idCompany, administratorId: nil, hourlyRate: 60.0, shifts: nil)
            dataService.createDBEmployee(uid: employee.id, employeeData: [
                "name": employee.name,
                "email" : employee.email,
                "companyId" :employee.companyId,
                "administratorId" : employee.administratorId ?? "",
                "isAdministrator" : employee.isAdministrator,
                "hourlyRate" : employee.hourlyRate
                ])

            dataService.getEmployeeById(forUID: employee.id) { (employee) in
                print(employee)
            }

        }



        //        dataService.getCompanyname(forUID: self.idCompany) { (name) in
        //            print(name)
        //
        //        }

        //        dataService.getEmployeeById(forUID: "C8831502-4429-415F-90C9-1EF3C3F0A84C") { (employee) in
        //            if let employee = employee {
        //                print(employee.name)
        //            }
        //        }

        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-dd-MM HH:mm a"
        let date1 = formatter.date(from: "2019-26-06 9:30 AM")?.timeIntervalSince1970 as! Double
        let date2 = formatter.date(from: "2019-26-06 4:30 PM")?.timeIntervalSince1970 as! Double
    }


    func test3() {
        AuthService.instance.registerUser(withEmail: "bill@apple.com", andPassword: "test1234") { (success, err) in
            if err is NSNull {
                if success == true {
                    DispatchQueue.main.async {
                        print("user logged")
                    }

                }
            }
        }
    }

    func test4()   {
        AuthService.instance.loginUser(withEmail: "bill@apple.com", andPassword: "test123") { (success, err) in
            if !success {
                print("not succefully login")
            } else {
                print("succefully login")
            }
            if err == nil {
                print("no error")
            } else {
                print("error")
            }

            print(credetial, "test4")
        }
    }
}
