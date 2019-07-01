//
//  CompanyDataServiceProtocol.swift
//  Punch
//
//  Created by Luiz on 7/1/19.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import Foundation
import Firebase
protocol CompanyDataServiceProtocol {
    var REF_BASE: DatabaseReference {get}
    var REF_COMPANY: DatabaseReference {get}
    func createDBCompany(uid: String, companyData: Dictionary<String, Any>)
    func getCompanyname(forUID uid: String, handler: @escaping (_ companyName: String) -> ())
    func getCompanyId(forCompany companyName: String, handler: @escaping (_ uid: String) -> ())
    
}
