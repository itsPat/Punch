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
  
  var idCompany = ""
  var name = ""
  
  let authService = AuthService.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.view.setGradientBackground(colorOne: CustomColors.blue, colorTwo: CustomColors.darkBlue)
      
      let dataService = DataService.instance
      //        dataService.createDBCompany(uid: UUID().uuidString, companyData: ["name": "Microsoft"])
      //        dataService.getCompanyId(forCompany: "Microsoft") { (id) in
      //            print(id)
      //            self.idCompany = id
      //            let employee = Employee1(id: UUID().uuidString,
      //                                     name: "Steve Jobs",
      //                                     email: "steve@microsoft.com",
      //                                     companyId: self.idCompany, administratorId: nil, hourlyRate: 60.0, shifts: nil)
      //            dataService.createDBEmployee(uid: employee.id, employeeData: [
      //                "name": employee.name,
      //                "email" : employee.email,
      //                "companyId" :employee.companyId,
      //                "administratorId" : employee.administratorId ?? "",
      //                "isAdministrator" : employee.isAdministrator,
      //                "hourlyRate" : employee.hourlyRate
      //                ])
      //
      //            dataService.getEmployeeById(forUID: employee.id) { (employee) in
      //                print(employee)
      //            }
      //
      //        }
      
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
      //        let shift = Shift1(id: "2F8F545A-9E3A-4073-B58B-F8B7774AB62B", employeeId: "A9DD96FA-0234-45FC-AA02-9A8A375B2E72", startTime: "9:00AM", finishTime: "5:00PM", punchInTime: date1, punchOutTime: date2)
      
      //        dataService.updateShiftById(uid: shift.id, shiftData: shift.dictionary())
      //        dataService.getShiftsByEmployeeId(forEmployee: "A9DD96FA-0234-45FC-AA02-9A8A375B2E72") { (shifts) in
      //            for _shift in shifts {
      //                print(shift.id, shift.employeeId)
      //            }
      //        }
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




