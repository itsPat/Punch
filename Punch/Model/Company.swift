//
//  Company.swift
//  Punch
//
//  Created by Luiz on 6/25/19.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import Foundation
import Firebase
public class Company {
    var id : String
    var name : String
    var employeesRef :[String : String] = [:]
    var employees: [Employee1]?

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }

    init(snapshot: DataSnapshot) {
        self.id = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        employeesRef = snapshotValue["employees"] as! [String : String]
        name = snapshotValue["name"] as! String
    }

    func dictionary () -> [String: Any]{
        return ["name" : self.name]
    }
}
