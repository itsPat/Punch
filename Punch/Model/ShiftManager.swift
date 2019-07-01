//
//  ShiftManager.swift
//  Punch
//
//  Created by Luiz on 7/1/19.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import Foundation

class ShiftManager {

    func selectShiftsBy(Employee employee: Employee1, withAGivenDate givenDate: Date) -> [Shift1]{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-dd-MM"
        let givendateComponents = Calendar.current.dateComponents([.year, .month, .day], from: givenDate)


        guard let givenYear = givendateComponents.year,
            let givenMonth = givendateComponents.month,
            let givenDay = givendateComponents.day else {
                print("error getting the components")
                return []
        }
        print(givenYear, givenMonth, givenDay)
        guard let shifts = employee.shifts else{
            print("There's not shifts to employee ")
            return []
        }

        var selectecShift : [Shift1] = []
        //        print(shifts[0].punchInTime)
        for shift in shifts {
            guard let shiftDate = TimeInterval(shift.startTime) else {
                print("empty cell")
                continue                
            }
            let shiftDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date(timeIntervalSince1970: shiftDate))

            guard let shiftYear = shiftDateComponents.year,
                let shiftMonth = shiftDateComponents.month,
                let shiftDay = shiftDateComponents.day else {
                    print("error getthing components of shift date")
                    continue
            }
            print(shiftYear, shiftMonth, shiftDay)
            if (givenYear == shiftYear) && (givenMonth == shiftMonth) && (givenDay == shiftDay) {
                selectecShift.append(shift)
            }
        }
        return selectecShift
    }

    func selectShiftsBy(Employees employees: [Employee1], withAGivenDate givenDate: Date ) -> [Employee1 : [Shift1]]{

        var dicEmployeeShift : [Employee1 : [Shift1]] = [:]
        for employee in employees {
            dicEmployeeShift[employee] = selectShiftsBy(Employee: employee, withAGivenDate: givenDate)
        }
        return dicEmployeeShift
    }


    func selectShiftsBy(Employee employee: Employee1, fromDate: Date, toDate: Date) -> [Shift1]{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "YYYY-dd-MM"

        var selectedShifts : [Shift1] = []
        guard let shifts = employee.shifts else {
            return selectedShifts
        }

        for shift in shifts {
            guard let shiftDate = TimeInterval(shift.startTime) else {
                continue
            }
            if shiftDate >= fromDate.timeIntervalSince1970 && shiftDate <= toDate.timeIntervalSince1970 {
                selectedShifts.append(shift)
            }
        }

        return selectedShifts
    }

    func selectShiftsBy(Employees employees: [Employee1], fromDate : Date, toDate : Date) -> [Employee1 : [Shift1]]{

        var dicEmployeeShift : [Employee1 : [Shift1]] = [:]
        for employee in employees {
            dicEmployeeShift[employee] = selectShiftsBy(Employee: employee, fromDate: fromDate, toDate: toDate)
        }
        return dicEmployeeShift
    }

}
