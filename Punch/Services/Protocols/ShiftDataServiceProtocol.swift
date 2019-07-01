//
//  ShiftDataServiceProtocol.swift
//  Punch
//
//  Created by Luiz on 7/1/19.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import Foundation
import Firebase
protocol ShiftDataServiceProtocol {
    var REF_BASE: DatabaseReference {get}
    var REF_WORK_SHIFT: DatabaseReference {get}
    func createDBShift(uid: String, shiftData: Dictionary<String, Any>)
    func getShiftsByEmployeeId(forEmployee employeeID: String, handler: @escaping (_ uid: [Shift1]) -> ())
    func updateShiftById(uid: String, shiftData: Dictionary<String, Any>)
    func getShiftsByEmployeeId(EmployeeId id: String, handler: @escaping (_ shifts: [Shift1]?) -> ())
    func setPunchInTimeWith(ShiftId shiftId: String, WithValue value: String )
    func setPunchOutTimeWith(ShiftId shiftId: String, WithValue value: String )
    func changeStatusOfShiftPaid(ShiftId shiftId: String, value: Bool )
}
