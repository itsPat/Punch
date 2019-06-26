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
    var startTime : String
    var finishTime : String
    var punchInTime : Date?
    var punchOutTime : Date?
    var hourWorked : TimeInterval {
        if let punchInTime = self.punchInTime, let punchOutTime = self.punchOutTime {
            return punchOutTime.timeIntervalSince(punchInTime)
        } else {
            return 0
        }
    }


    init(id: String, employeeId: String, startTime: String, finishTime: String, punchInTime: Date?, punchOutTime: Date?) {
        self.id = id
        self.employeeId = employeeId
        self.startTime = startTime
        self.finishTime = finishTime
        self.punchOutTime = nil
        self.punchInTime = nil
    }

    func dictionary() -> [String: Any] {
        let dic : [String: Any] = [
    "employeeId": employeeId,
    "startTime" : startTime,
    "finishTime" : finishTime,
    "punchOutTime" : punchOutTime ?? 0,
    "punchInTime" : punchInTime ?? 0
        ]

    return dic
    }

    init(snapshot: DataSnapshot) {

        self.id = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.employeeId = snapshotValue["employeeId"] as! String
        self.startTime = snapshotValue["startTime"] as! String
        self.finishTime = snapshotValue["finishTime"] as! String
        if let time = snapshotValue["administratorId"] as? Double {
            self.punchInTime = Date(timeIntervalSince1970: TimeInterval( time))
        }
        if let time = snapshotValue["punchInTime"] as? Double {
            self.punchOutTime = Date(timeIntervalSince1970: TimeInterval( time))
        }
    }

}
