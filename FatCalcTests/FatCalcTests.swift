//
//  FatCalcTests.swift
//  FatCalcTests
//
//  Created by segev perets on 09/03/2023.
//

import XCTest
@testable import FatCalc

final class FatCalcTests: XCTestCase {
    var calc : Calculator?
    
    override func setUpWithError() throws {
        calc = Calculator()
    }

    override func tearDownWithError() throws {
        calc = nil
    }
/**
 hips : 90 , wrist: 15, thigh: 100, calf, 50, age 50 = 29.53
 */
    func testFemaleTape() throws {
        let r = Double(calc!.tapeFatCalcWomen(age: "50", hips: "90", thigh: "100", calf: "50", wrist: "15", system: .Metric)!)!
        
        XCTAssertEqual(r, 29.5,accuracy: 0.5)
        
    }
    /**
     hips : 120 , wrist: 17, thigh: 150, calf, 20, age 20 = 72
     */
        func testFemaleTape2() throws {
            let rr = Double(calc!.tapeFatCalcWomen(age: "20", hips: "120", thigh: "150", calf: "20", wrist: "17", system: .Metric)!)!
            
            XCTAssertEqual(rr, 72,accuracy: 0.1)

        }
    /**
     age 20, hips 80, wrist: 17, waist 90, forarm 30 = 9.06
     */
    func testMaleTape1 () {
        let r = Double(calc!.tapeFatCalcMen(age: "20", hips: "80", waist: "90", forearm: "20", wrist: "17",system: .Metric))!
        
        XCTAssertEqual(r, 20.87,accuracy: 0.1)
    }
    func testMaleTape2 () {
        let r = Double(calc!.tapeFatCalcMen(age: "50", hips: "100", waist: "120", forearm: "50", wrist: "22", system: .Metric))!
        
        XCTAssertEqual(r, 5.12,accuracy: 0.1)
    }
    func testMaleCaliper1 () {
        
        let r = Double(calc!.calcMenBodyFat(age: "50", chest: "15", abdominal: "15", thigh: "20")!)!
        XCTAssertEqual(r, 17.3,accuracy: 0.1)
    }
    
    func testMaleCaliper2 () {
        
        let r = Double(calc!.calcMenBodyFat(age: "20", chest: "35", abdominal: "50", thigh: "40")!)!
        XCTAssertEqual(r, 32.5,accuracy: 0.1)
    }
    
    func testFemaleCaliper1 () {
        let r = Double(calc!.calcWomenBodyFat(age: "20", triceps: "30", suprailiac: "20", thigh: "40")!)!
        XCTAssertEqual(r, 33,accuracy: 1)
    }
    func testFemaleCaliper2 () {
        let r = Double(calc!.calcWomenBodyFat(age: "50", triceps: "50", suprailiac: "30", thigh: "50")!)!
        XCTAssertEqual(r, 41.6,accuracy: 3)
    }
    
    
    
    
    
    
    
    
    
    
    //    func testPerformanceExample() throws {
    //        // This is an example of a performance test case.
    //        measure {
    //            // Put the code you want to measure the time of here.
//        }
//    }

}
