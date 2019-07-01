//
//  PaymentManager.swift
//  Punch
//
//  Created by Luiz on 7/1/19.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import Foundation

class PaymentManager {

    func calculateAmountOwedOfATimeIntervalTo(Employee employee: Employee1, From initialDate: Date, To finalDate: Date) -> Double{
        let shiftManager = ShiftManager()
        let shifts = shiftManager.SelectShiftsBy(Employee: employee, fromDate: initialDate, toDate: finalDate)
        var amountOwedTotal : Double = 0.0
        for shift in shifts {
            if shift.isPaid == false {
                amountOwedTotal += shift.amountOwed
            }
        }
        return amountOwedTotal
    }
}
