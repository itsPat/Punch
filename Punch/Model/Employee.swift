//
//  Employee.swift
//  Punch
//
//  Created by Luiz on 6/25/19.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import Foundation

public class Employee1 {
    var id: String
    var name: String
    var companyId: String
    var administratorId:String?
    var isAdministrator: Bool
    var hourlyRate: Double

    init(id: String, name: String, companyId: String, administratorId: String, isAdministrator: Bool = false, hourlyRate: Double) {
        self.id = id
        self.name = name
        self.companyId = companyId
        self.administratorId = administratorId
        self.isAdministrator = isAdministrator
        self.hourlyRate  = hourlyRate
    }
}
