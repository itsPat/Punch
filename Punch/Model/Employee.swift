//
//  Employee.swift
//  Punch
//
//  Created by Luiz on 6/25/19.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import Foundation
import Firebase
public class Employee1 : Hashable{
    public static func == (lhs: Employee1, rhs: Employee1) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    var id: String
    var name: String
    var companyId: String
    var email: String
    var administratorId:String?
    var isAdministrator: Bool
    var amountOwed: Double
    var hourlyRate: Double
    var shifts: [Shift1]?

    init(id: String, name: String, email: String, companyId: String, administratorId: String?, isAdministrator: Bool = false,
         amountOwed: Double = 0.0, hourlyRate: Double, shifts: [Shift1]?) {
        self.id = id
        self.name = name
        self.companyId = companyId
        self.email = email
        self.administratorId = administratorId ?? ""
        self.isAdministrator = isAdministrator
        self.amountOwed = amountOwed
        self.hourlyRate  = hourlyRate
        self.shifts = shifts
    }

    init(snapshot: DataSnapshot) {

        self.id = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.name = snapshotValue["name"] as! String
        self.companyId = snapshotValue["companyId"] as! String
        self.email = snapshotValue["email"] as! String
        self.administratorId = snapshotValue["administratorId"] as? String
        self.isAdministrator = snapshotValue["isAdministrator"] as? Bool ?? false
        self.amountOwed = snapshotValue["amountOwed"] as? Double ?? 0.0
        self.hourlyRate = snapshotValue["hourlyRate"] as? Double ?? 0.0
    }

    func dictionary() -> [String: Any] {
        let dic : [String: Any] = [
            "id": id,
            "name" : name,
            "companyId" : companyId,
            "email" : email,
            "administratorId" : administratorId ?? "",
            "isAdministrator" : isAdministrator ,
            "amountOwed" : amountOwed,
            "hourlyRate" : hourlyRate,
        ]

        return dic
    }

}

