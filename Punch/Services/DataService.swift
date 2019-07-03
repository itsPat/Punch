//
//  DataService.swift
//  Punch
//
//  Created by Luiz on 6/25/19.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import Foundation
import Firebase
import os.log

let DB_BASE = Database.database().reference()
class DataService: CompanyDataServiceProtocol, EmployeeDataServiceProtocol, ShiftDataServiceProtocol {

    static let instance = DataService()

    private var _REF_BASE = DB_BASE
    private var _REF_COMPANY = DB_BASE.child("Company")
    private var _REF_EMPLOYEE = DB_BASE.child("Employee")
    private var _REF_WORK_SHIFT = DB_BASE.child("Shift")
    private var _REF_DBUSER = DB_BASE.child("User")
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }

    var REF_DBUSER: DatabaseReference {
        return _REF_DBUSER
    }
    var REF_COMPANY: DatabaseReference {
        return _REF_COMPANY
    }

    var REF_EMPLOYEE: DatabaseReference {
        return _REF_EMPLOYEE
    }

    var REF_WORK_SHIFT: DatabaseReference {
        return _REF_WORK_SHIFT
    }

    //MARK : DBUSER Functions
    func createDBUser(uid: String, userData: [String: Any]) {
        REF_DBUSER.child(uid).updateChildValues(userData)
    }

    func getUserByUID(foruid uid: String, AndPassword password: String, handler: @escaping (_ user: Credential) -> ()){
        REF_DBUSER.child(uid).observeSingleEvent(of: .value) { (userSnapshot) in
            let user = Credential(snapshot: userSnapshot, password: password )
            handler(user)
        }
    }


    //MARK: Company Methods
    func createDBCompany(uid: String, companyData: Dictionary<String, Any>) {
        REF_COMPANY.child(uid).updateChildValues(companyData)
    }

    func getCompanyname(forUID uid: String, handler: @escaping (_ companyName: String) -> ()) {


        REF_COMPANY.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }

            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "name").value as! String)
                }
            }
        }
    }

    func getCompanyId(forCompany companyName: String, handler: @escaping (_ uid: String) -> ()) {
        REF_COMPANY.observeSingleEvent(of: .value, with:  { (userSnapshot) in

            guard userSnapshot.exists() else {
                print("Snapshot is null \(#file) - \(#function) -\(#line)")
                return
            }
            if userSnapshot.value is NSNull {
                print("Snapshot is null \(#file) - \(#function) -\(#line)")
                return
            }


            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else {
                print("Snapshot is null \(#file) - \(#function) -\(#line)")
                return }
            for user in userSnapshot {
                if user.childSnapshot(forPath: "name").value  as! String == companyName {
                    handler(user.key)
                }
            }
        }) { (error) in
            print(error)
        }
    }

    //MARK: -Employee Methods
    func createDBEmployee(uid: String, employeeData: Dictionary<String, Any>) {

        REF_EMPLOYEE.child(uid).updateChildValues(employeeData)
        if let companyId = employeeData["companyId"] as? String {
            REF_COMPANY.child(companyId).child("employees").updateChildValues([ uid: "Employee/\(uid)"])
        }
    }

    func getShiftById(ShiftId shiftId: String,handler: @escaping (_ shifts: Shift1?) -> ()) {
        REF_WORK_SHIFT.child(shiftId).observeSingleEvent(of: .value) { (shiftSnapshot) in
            guard shiftSnapshot.exists() else {
                print("shiftsnapshot doesn't exist -\(#file) - \(#function) - \(#line)")
                return
            }
            let shift = Shift1(snapshot: shiftSnapshot)
            handler(shift )
        }
    }

    func getEmployeename(forUID uid: String, handler: @escaping (_ employeeName: String) -> ()) {

        REF_EMPLOYEE.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }

            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "name").value as! String)
                }
            }
        }
    }

    func getEmployeeId(forEmployee employeeName: String, handler: @escaping (_ uid: String) -> ()) {
        REF_EMPLOYEE.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if user.childSnapshot(forPath: "name").value  as! String == employeeName {
                    handler(user.key)
                }
            }
        }
    }
    

    func getEmployeeByEmail(forEmail employeeEmail: String, handler: @escaping (_ uid: Employee1) -> ()) {
        REF_EMPLOYEE.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                if user.childSnapshot(forPath: "email").value  as! String == employeeEmail {
                    let employee = Employee1(snapshot: user)
                    employee.id = user.key
                    handler(employee)
                }
            }
        }
    }

    func getEmployeeById(forUID uid: String, handler: @escaping (_ employeeName: Employee1?) -> ()) {

        REF_EMPLOYEE.child(uid).observeSingleEvent(of: .value) { (userSnapshot) in
            handler(Employee1(snapshot: userSnapshot))
            //            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            //
            //            for user in userSnapshot {
            //                if user.key == uid {
            //
            //                    let employee = Employee1(snapshot: user)
            //                    handler(employee)
            //                }
            //            }
        }
    }

    func changeValueOfAmountOwedWith(EmployeeId employeeId: String, value: Double){
        REF_EMPLOYEE.child(employeeId).updateChildValues(["amountOwed": value])
    }

    func getEmployeesByCompanyId(companyId: String, handler: @escaping (_ employees: [Employee1]?) -> ()) {

        REF_COMPANY.child(companyId).observeSingleEvent(of: .value) { (snapshot) in
            var myEmployees: [Employee1] = []
            if let company = snapshot.value as? [String: Any] {
                if let refernces = company["employees"] as? [String: String] {

                    for ref in refernces.values {
                        self.REF_BASE.child(ref).observeSingleEvent(of: .value, with: { (snapshot) in
                            let employee = Employee1(snapshot: snapshot)
                            myEmployees.append(employee)
                            if refernces.values.count == myEmployees.count {
                                os_log("Testing %@", myEmployees)
                                handler(myEmployees)

                            }
                        })
                    }
                }
            }
        }
    }

    func createDBShift(uid: String, shiftData: Dictionary<String, Any>) {
        REF_WORK_SHIFT.child(uid).updateChildValues(shiftData)
        if let employeeId = shiftData["employeeId"] as? String {
            REF_EMPLOYEE.child(employeeId).child("shifts").updateChildValues([ uid: "Shift/\(uid)"])
        }
    }

    func changeStatusOfShiftPaid(ShiftId shiftId: String, value: Bool ) {
        REF_WORK_SHIFT.child(shiftId).setValue(value, forKey: "isPaid")
    }
    
    func getCompany(forUID uid: String, handler: @escaping (_ companyName: Company) -> ()) {
        REF_COMPANY.observeSingleEvent(of: .value) { (companySnapshot) in
            guard let companySnapshot = companySnapshot.children.allObjects as? [DataSnapshot] else { return }
            for company in companySnapshot {
                if company.key == uid {
                    handler(Company(snapshot: company))
                }
            }
        }
    }

    func getShiftsByEmployeeId(forEmployee employeeID: String, handler: @escaping (_ uid: [Shift1]) -> ()) {
        REF_WORK_SHIFT.observeSingleEvent(of: .value) { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            var shifts = [Shift1]()
            for shif in snapshot {

                if shif.childSnapshot(forPath: "employeeId").value  as! String == employeeID {
                    shifts.append(Shift1(snapshot: shif))

                }
            }
            handler(shifts)
        }
    }

    func updateShiftById(uid: String, shiftData: Dictionary<String, Any>) {
        REF_WORK_SHIFT.child(uid).updateChildValues(shiftData)
    }

    func getShiftsByEmployeeId(EmployeeId id: String, handler: @escaping (_ shifts: [Shift1]?) -> ()) {

        REF_EMPLOYEE.child(id).observeSingleEvent(of: .value) { (snapshot) in
            var myshifts: [Shift1] = []
            if let employee = snapshot.value as? [String: Any] {
                if let refernces = employee["shifts"] as? [String: String] {

                    for ref in refernces.values {
                        self.REF_BASE.child(ref).observeSingleEvent(of: .value, with: { (snapshot) in

                            myshifts.append(Shift1(snapshot: snapshot))

                            if refernces.values.count == myshifts.count {

                                handler(myshifts)
                            }
                        })
                    }
                }
            }
        }
    }


    func getAllEmployeeWithShiftByCompany(companyId: String, handler: @escaping (_ employees : [Employee1]?) ->  () ) {
        getEmployeesByCompanyId(companyId: companyId) { (employeesNet) in
            guard let employeesNet = employeesNet else {
                print("Error loading employees - \(#file) - \(#function) - \(#line)")
                return
            }
            for employeeNet in employeesNet {
                self.REF_EMPLOYEE.child(employeeNet.id).child("shifts").observeSingleEvent(of: .value) { (snapshot) in
                    var myshifts: [Shift1] = []
                    if let shiftsref = snapshot.value as? [String: Any] {
                        if let refernces = shiftsref["shifts"] as? [String: String] {

                            for ref in refernces.values {
                                self.REF_BASE.child(ref).observeSingleEvent(of: .value, with: { (snapshot) in

                                    myshifts.append(Shift1(snapshot: snapshot))

                                    if refernces.values.count == myshifts.count {
                                        employeeNet.shifts? = myshifts
                                        //                                      handler(myshifts)
                                    }
                                })
                            }
                        }
                    }
                    handler(employeesNet)
                    //                 if employeesNet.count ==
                    print(employeesNet)

                }
            }

        }
    }
    
    func getAllShiftsOf(CompanyID companyID: String, handler: @escaping (_ uid: [Shift1]?) -> ()) {
        
        REF_WORK_SHIFT.observeSingleEvent(of: .value) { (shiftSnapShot) in
            guard let shiftSnapshot = shiftSnapShot.children.allObjects as? [DataSnapshot] else {return}
            guard shiftSnapShot.exists() else {
                return
            }
            var shiftsInDatabase : [Shift1]  = []
            for shiftData in shiftSnapshot {
                let shift = Shift1(snapshot: shiftData)
                shiftsInDatabase.append(shift)
            }
            
            var employees : [Employee1] = []
            self.REF_EMPLOYEE.observeSingleEvent(of: .value, with: { (employeeSnapshot) in
                var internEmployees : [Employee1] = []
                guard let employeeSnapshot = employeeSnapshot.children.allObjects as? [DataSnapshot] else {return}
                for snapshot in employeeSnapshot {
                    let employee = Employee1(snapshot: snapshot)
                    if employee.companyId == companyID {
                        internEmployees.append(employee)
                    }
                }
                
                var shiftsByCompany :[Shift1] = []
                
                for shiftInDatabase in shiftsInDatabase {
                    for employee in internEmployees {
                        if shiftInDatabase.employeeId == employee.id {
                            shiftsByCompany.append(shiftInDatabase)
                        }
                    }
                }
                handler(shiftsByCompany)
            })
        }
    }


    func setPunchInTimeWith(ShiftId shiftId: String, WithValue value: String ){
        REF_WORK_SHIFT.child(shiftId).child("punchInTime").setValue(value)
    }

    func setPunchOutTimeWith(ShiftId shiftId: String, WithValue value: String ){
        REF_WORK_SHIFT.child(shiftId).child("punchOutTime").setValue(value)
    }



}
