//
//  PunchTests.swift
//  PunchTests
//
//  Created by Luiz on 6/27/19.
//  Copyright © 2019 Patrick Trudel. All rights reserved.
//

import XCTest
import Pods_Punch
@testable import Punch
@testable import Firebase 



class PunchTests: XCTestCase {

    override func setUp() {
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func test_CreateShiftForEmployee(){
        let uid = UUID().uuidString
        let formatter = DateFormatter()

        formatter.dateFormat = "YYYY-dd-MM HH:mm a"
        let employeeId = "3DD24250-1DA6-4C03-8AD4-DC0DA2009271"
        let punchInTime = "2019-26-06 9:30 AM"
        let punchOutTime = "2019-26-06 4:30 PM"
        let shift1 = Shift1(id:uid , employeeId: employeeId , hourlyRate: 60.0, startTime: "9:00 AM", finishTime: "4:30 PM", punchInTime: "2019-27-06 9:3 AM" , punchOutTime: "2019-27-06 4:30 PM")
        DataService.instance.createDBShift(uid: UUID().uuidString, shiftData: shift1.dictionary())

//        DataService.instance.REF_WORK_SHIFT.child(uid).setValue(nil)

    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }



}
