//
//  EmployeeDataServiceProtocol.swift
//  Punch
//
//  Created by Luiz on 7/1/19.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import Foundation
import Firebase
protocol EmployeeDataServiceProtocol {
    var REF_BASE: DatabaseReference {get}
    var REF_EMPLOYEE: DatabaseReference {get}
    func createDBEmployee(uid: String, employeeData: Dictionary<String, Any>)
    func getEmployeename(forUID uid: String, handler: @escaping (_ employeeName: String) -> ())
    func getEmployeeId(forEmployee employeeName: String, handler: @escaping (_ uid: String) -> ())
    func getEmployeeByEmail(forEmail employeeEmail: String, handler: @escaping (_ uid: Employee1) -> ())
    func getEmployeeById(forUID uid: String, handler: @escaping (_ employeeName: Employee1?) -> ())
    func getEmployeesByCompanyId(companyId: String, handler: @escaping (_ employees: [Employee1]?) -> ())
    func getAllEmployeeWithShiftByCompany(companyId: String, handler: @escaping (_ employees : [Employee1]?) ->  () )
    func changeValueOfAmountOwedWith(EmployeeId employeeId: String, value: Double)
}
