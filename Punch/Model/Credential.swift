//
//  Credential.swift
//  Punch
//
//  Created by Luiz on 6/26/19.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import Foundation
import Firebase

struct Credential {
    var uid: String
    var name: String
    var password: String
    var companyId: String
    var email: String
    var administratorId:String?
    var isAdministrator: Bool = false
    var hourlyRate : Double

    init (){
        self.uid = ""
        self.name = ""
        self.password = ""
        self.companyId = ""
        self.email = ""
        self.administratorId = ""
        self.hourlyRate = 0
    }
    init(uid: String, dictionary: [String: Any]) {
        self.init()
        self.uid = uid
        self.name = dictionary["name"] as? String ?? ""
        self.password = dictionary["name"] as? String ?? ""
        self.companyId = dictionary["companyId"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.administratorId = dictionary["administratorId"] as? String ?? ""
        self.isAdministrator = dictionary["isAdministrator"] as? Bool ?? false
        self.hourlyRate = dictionary["hourlyRate"] as? Double ?? 0
    }

    init(snapshot: DataSnapshot, password: String) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        self.uid =  snapshotValue["id"] as! String
        self.name = snapshotValue["name"] as! String
        self.companyId = snapshotValue["companyId"] as! String
        self.email = snapshotValue["email"] as! String
        self.administratorId = snapshotValue["administratorId"] as? String
        self.isAdministrator = snapshotValue["isAdministrator"] as? Bool ?? false
        self.hourlyRate = snapshotValue["hourlyRate"] as? Double ?? 0
        self.password = password
    }
}
