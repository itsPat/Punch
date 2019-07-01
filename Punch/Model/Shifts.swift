//
//  Shifts.swift
//  Punch
//
//  Created by Luiz on 6/25/19.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import Foundation
import Firebase

public class Shift1 {

    var id : String
    var employeeId: String
    var hourlyRate: Double
    var isPaid: Bool
    var startTime : String
    var finishTime : String
    var punchInTime : TimeInterval?
    var punchOutTime : TimeInterval?

    var amountOwed : Double {
        return (hourWorked * hourlyRate) / 60
    }
    var hourWorked : TimeInterval {
        if let punchInTime = self.punchInTime, let punchOutTime = self.punchOutTime {
            return punchOutTime - punchInTime
        } else {
            return 0
        }
    }


    init(id: String, employeeId: String, hourlyRate: Double, isPaid: Bool = false, startTime: String, finishTime: String, punchInTime: TimeInterval?, punchOutTime: TimeInterval?) {
        self.id = id
        self.employeeId = employeeId
        self.hourlyRate = hourlyRate
        self.isPaid = isPaid
        self.startTime = startTime
        self.finishTime = finishTime
        self.punchOutTime = punchOutTime
        self.punchInTime = punchInTime

    }

    func dictionary() -> [String: Any] {
        let dic : [String: Any] = [
            "employeeId": employeeId,
            "hourlyRate" : hourlyRate,
            "isPaid" : isPaid,
            "startTime" : startTime,
            "finishTime" : finishTime,
            "punchOutTime" : punchOutTime ?? 0,
            "punchInTime" : punchInTime ?? 0
        ]

        return dic
    }

    init(snapshot: DataSnapshot) {

        self.id = snapshot.key
        let snapshotValue = snapshot.value as! [String: Any]
        self.employeeId = snapshotValue["employeeId"] as! String
        self.hourlyRate = snapshotValue["hourlyRate"] as! Double
        self.isPaid = snapshotValue["isPaid"] as? Bool ?? false
        self.startTime = snapshotValue["startTime"] as! String
        self.finishTime = snapshotValue["finishTime"] as! String
        self.punchInTime = snapshotValue["punchInTime"] as? TimeInterval ?? 0
        self.punchOutTime = snapshotValue["punchOutTime"] as? TimeInterval ?? 0
    }
    
}
