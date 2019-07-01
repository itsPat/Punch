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
    var latitude : Double
    var longitude : Double

    init(id: String, name: String, latitude : Double = 0, longitude : Double = 0) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }

    init(snapshot: DataSnapshot) {
        self.id = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        employeesRef = snapshotValue["employees"] as! [String : String]
        name = snapshotValue["name"] as! String
        latitude = snapshotValue["latitude"] as? Double ?? 0
        longitude = snapshotValue["longitude"] as? Double ?? 0
    }

    func dictionary () -> [String: Any]{
        
        return ["name" : self.name,
                "latitude" : self.latitude,
                "longitude": self.longitude]
    }
}
