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
    var startTime : String
    var finishTime : String
    var punchInTime : String?
    var punchOutTime : String?

    var amountOwed : Double {
        return (hourWorked * hourlyRate) / 60
    }
    var hourWorked : TimeInterval {
        let dateFormatter = DateFormatter()

        if punchInTime == nil || punchOutTime == nil {
            return 0
        }
        dateFormatter.dateFormat = "YYYY-dd-MM HH:mm a"
        if let datePunchInTime = dateFormatter.date(from: self.punchInTime! ),
            let datePuchOutTime = dateFormatter.date(from: self.punchOutTime! ) {
            return datePuchOutTime.timeIntervalSince(datePunchInTime)
        } else {
            return 0
        }

    }


    init(id: String, employeeId: String, hourlyRate: Double, startTime: String, finishTime: String, punchInTime: String?, punchOutTime: String?) {
        self.id = id
        self.employeeId = employeeId
        self.hourlyRate = hourlyRate
        self.startTime = startTime
        self.finishTime = finishTime
        self.punchOutTime = nil
        self.punchInTime = nil
    }

    func dictionary() -> [String: Any] {
        let dic : [String: Any] = [
    "employeeId": employeeId,
    "hourlyRate" : hourlyRate,
    "startTime" : startTime,
    "finishTime" : finishTime,
    "punchOutTime" : punchOutTime ?? "",
    "punchInTime" : punchInTime ?? ""
        ]

    return dic
    }

    init(snapshot: DataSnapshot) {

        self.id = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.employeeId = snapshotValue["employeeId"] as! String
        self.hourlyRate = snapshotValue["hourlyRate"] as! Double
        self.startTime = snapshotValue["startTime"] as! String
        self.finishTime = snapshotValue["finishTime"] as! String
        if let punchInTime = snapshotValue["punchInTime"] as? String {
            self.punchInTime = punchInTime
        }
        if let punchOutTime = snapshotValue["punchOutTime"] as? String {
            self.punchOutTime = punchOutTime
        }
    }

}
