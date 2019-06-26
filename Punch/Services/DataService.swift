//
//  DataService.swift
//  Punch
//
//  Created by Luiz on 6/25/19.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
class DataService {

    static let instance = DataService()

    private var _REF_BASE = DB_BASE
    private var _REF_COMPANY = DB_BASE.child("Company")
    private var _REF_EMPLOYEE = DB_BASE.child("Employee")
    private var _REF_WORK_SHIFT = DB_BASE.child("Shift")

    var REF_BASE: DatabaseReference {
        return _REF_BASE
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

    func createDBEmployee(uid: String, employeeData: Dictionary<String, Any>) {
        REF_EMPLOYEE.child(uid).updateChildValues(employeeData)
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

    func getEmployeeById(forUID uid: String, handler: @escaping (_ employeeName: Employee1?) -> ()) {

        REF_EMPLOYEE.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }

            for user in userSnapshot {
                if user.key == uid {

                    let employee = Employee1(snapshot: user)
                    handler(employee)
//                    handler(user.childSnapshot(forPath: "Name").value as! String)

                }
            }
        }
    }





    func createDBShift(uid: String, shiftData: Dictionary<String, Any>) {
        REF_WORK_SHIFT.child(uid).updateChildValues(shiftData)
    }

//    func getShifById

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

}
