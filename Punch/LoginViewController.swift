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

 //       test_CreateShiftForEmployee()
//        testCreateShift()
//        testSetPunch()
        test_set_Punch()

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
    func testCompanyAndEmployee() {
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
    }


    func testCreateShift() {

        let dataService = DataService.instance

        let shift : [String: Any] = [
            "employeeId": "A9DD96FA-0234-45FC-AA02-9A8A375B2E72",
            "hourlyRate" : 60,
            "startTime" : "9:00 AM",
            "finishTime" : "5:00 PM",
            "punchOutTime" : 0,
            "punchInTime" : 0
        ]

        dataService.createDBShift(uid: UUID().uuidString, shiftData: shift)
        
        //        let shift = Shift1(id: "2F8F545A-9E3A-4073-B58B-F8B7774AB62B", employeeId: "A9DD96FA-0234-45FC-AA02-9A8A375B2E72", startTime: "9:00AM", finishTime: "5:00PM", punchInTime: date1, punchOutTime: date2)

        //        dataService.updateShiftById(uid: shift.id, shiftData: shift.dictionary())
        //        dataService.getShiftsByEmployeeId(forEmployee: "A9DD96FA-0234-45FC-AA02-9A8A375B2E72") { (shifts) in
        //            for _shift in shifts {
        //                print(shift.id, shift.employeeId)
        //            }
        //        }
    }

    func test_CreateShiftForEmployee(){
        let uid = UUID().uuidString
        let formatter = DateFormatter()

        formatter.dateFormat = "YYYY-dd-MM HH:mm a"
        let employeeId = "3DD24250-1DA6-4C03-8AD4-DC0DA2009271"
        let punchInTime = "2019-26-06 9:30 AM"
        let punchOutTime = "2019-26-06 4:30 PM"
        let shift1 = Shift1(id:uid , employeeId: employeeId , hourlyRate: 60.0, startTime: "9:00 AM", finishTime: "4:30 PM", punchInTime: "2019-27-06 9:3 AM" , punchOutTime: "2019-27-06 4:30 PM")
        DataService.instance.createDBShift(uid: UUID().uuidString, shiftData: shift1.dictionary())


    }

    func test_set_Punch() {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-dd-MM HH:mm a"
        let shiftId = "1C4C668E-8A16-441A-B392-80A2FFD00017"
        let employeeId = "3DD24250-1DA6-4C03-8AD4-DC0DA2009271"
        let punchInTime = "2019-26-06 9:30 AM"
        let punchOutTime = "2019-26-06 4:30 PM"
        DataService.instance.setPunchInTimeWith(ShiftId: shiftId,
                                                WithValue: punchInTime)
        DataService.instance.setPunchOutTimeWith(ShiftId: shiftId,
                                                 WithValue: punchOutTime)
        DataService.instance.getShiftsByEmployeeId(EmployeeId: employeeId) { (shifts) in
            guard let shifts = shifts else {return}
            for shift in shifts {
                guard let punchInTime = shift.punchInTime, let punchOutTime = shift.punchOutTime else {
                    print("Error converting date")
                    return
                }
                DispatchQueue.main.async {
                    print(formatter.date(from: punchInTime))
                    print(formatter.date(from: punchOutTime))
                }

            }
        }
    }
    func test2() {
        let dataService = DataService.instance.REF_EMPLOYEE.queryOrderedByKey().queryEqual(toValue: "A9DD96FA-0234-45FC-AA02-9A8A375B2E72").queryLimited(toFirst: 1).observe(.value) { (snap) in
            let t = snap.value
            DispatchQueue.main.async {
                print(t)
            }

        }
        print(dataService)
    }

    func testSetPunch() {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-dd-MM HH:mm a"

        DataService.instance.setPunchInTimeWith(ShiftId: "2F8F545A-9E3A-4073-B58B-F8B7774AB62B",
                                                WithValue: "2019-26-06 9:30 AM")
        DataService.instance.setPunchOutTimeWith(ShiftId: "2F8F545A-9E3A-4073-B58B-F8B7774AB62B",
                                                 WithValue: "2019-26-06 4:30 PM")

        DataService.instance.getShiftsByEmployeeId(EmployeeId: "A9DD96FA-0234-45FC-AA02-9A8A375B2E72") { (shifts) in
            guard let shifts = shifts else {return}
            for shift in shifts {
                guard let punchInTime = shift.punchInTime, let punchOutTime = shift.punchOutTime else {
                    print("Error converting date")
                    return
                }
                DispatchQueue.main.async {
                    print(formatter.date(from: punchInTime))
                    print(formatter.date(from: punchOutTime))
                }

            }
        }
    }

    func test4() {

    }
}


