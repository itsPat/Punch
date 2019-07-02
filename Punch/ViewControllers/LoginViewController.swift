//
//  LoginViewController.swift
//  Punch
//
//  Created by Patrick Trudel on 2019-06-24.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import UIKit
import LocalAuthentication
import Firebase

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

        

        DataService.instance.createDBCompany(uid: UUID().uuidString, companyData: ["name" : " test"])
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

//        testgetAllEmployeeWithShiftByCompany()
//        testgetAllEmployeeShiftsByCompany()
//        deleteTestCompany()
        getAllByDate()
//        testCreateCompany()
//testCreateEmployee()
//        dataService.changeValueOfAmountOwedWith(EmployeeId: "11196A8A-46CD-4C28-88A9-05F0B2979A77", value: 1500.0)
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
        userTextField.setCornerRadius()
        passTextField.setCornerRadius()
    }
}

extension LoginViewController {
    func testgetAllEmployeeWithShiftByCompany() {
        let dataService : EmployeeDataServiceProtocol = DataService.instance
        let uidLightHouse = "7C5A37CA-A6E9-47D6-A69E-CA4144B75AA7"
        dataService.getAllEmployeeWithShiftByCompany(companyId: uidLightHouse) { (employees) in

            DispatchQueue.main.async {
                print(employees)
            }
        }
    }

    func testgetAllEmployeeShiftsByCompany() {
        let dataService = DataService.instance
        let uidLightHouse = "7C5A37CA-A6E9-47D6-A69E-CA4144B75AA7"
        dataService.getAllEmployeeWithShiftByCompany(companyId: uidLightHouse) { (employees) in
            DispatchQueue.main.async {
                print(employees)
            }
        }
    }

    func deleteTestCompany() {
        let data = DataService.instance
//        let list = ["F673E6A1-8965-41E5-BC38-A6E57904D931" ,
//                    "F8631EDD-001E-4EF8-80B8-D3ACA91D5520" ,
//                    "FB72E947-3A8B-46D2-8516-FFCE10EFD685" ,
//                    "FC399C6F-1FE9-4271-80B5-486F433610D8" ,
//                    "FE860387-50DA-4FD4-884C-61FAD0CA005D" ,
//                    "FFA0279C-D3A3-4300-AA17-496073A425B5"]
//        for item in list {
//            Database.database().reference().child("Company").child(item).removeValue()
//        }

    }

    func getAllByDate() {
        let light = "7C5A37CA-A6E9-47D6-A69E-CA4144B75AA7"
        DataService.instance.getAllShiftsOfAdate(forCompanyID: light, date: Date()) { (shift) in

        }
    }

    func testCreateCompany(){

        let uidPuch = UUID().uuidString
        let lightHouse = Company(id: uidPuch, name: "Punch")
        DataService.instance.createDBCompany(uid: uidPuch, companyData: lightHouse.dictionary())
    }

    func testCreateEmployee() {
        let punch = "FD69FCED-C156-469A-82C2-05A24D787B76"

        let uidRussel = UUID().uuidString
        let russel = Employee1(id: uidRussel, name: "Russel", email: "russel@punch.ca", companyId: punch, administratorId: nil, isAdministrator: true, amountOwed: 0, hourlyRate: 60, shifts: nil)
        let uidPat = UUID().uuidString
        let pat = Employee1(id: uidPat, name: "Pat", email: "pat@punch.ca", companyId: punch, administratorId: uidRussel, isAdministrator: false, amountOwed: 0, hourlyRate: 35, shifts: nil)

        let d = DataService.instance
        d.createDBEmployee(uid: uidRussel, employeeData: russel.dictionary())
        d.createDBEmployee(uid: uidPat, employeeData: pat.dictionary())
    }
}

