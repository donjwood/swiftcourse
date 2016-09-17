//
//  CalculatorBrainTests.swift
//  Calculator
//
//  Created by Donald Wood on 3/24/15.
//  Copyright (c) 2015 Donald Wood. All rights reserved.
//

import UIKit
import XCTest

class CalculatorBrainTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testBasicMathOps () {
        
        let calcBrain = CalculatorBrain()
        
        //Addition test
        calcBrain.pushOperand(3.0)
        calcBrain.pushOperand(2.0)
        var result = calcBrain.performOperation("+")
        XCTAssertEqual(result!, 5.0, "Addition result invalid.")
        
        //Subtraction test
        calcBrain.clearOps()
        calcBrain.pushOperand(5.0)
        calcBrain.pushOperand(4.0)
        result = calcBrain.performOperation("−")
        XCTAssertEqual(result!, 1.0, "Subtraction result invalid.")
        
        //Multiplication test
        calcBrain.clearOps()
        calcBrain.pushOperand(3.0)
        calcBrain.pushOperand(2.0)
        result = calcBrain.performOperation("×")
        XCTAssertEqual(result!, 6.0, "Multiplication result invalid.")
        
        //Division test
        calcBrain.clearOps()
        calcBrain.pushOperand(6.0)
        calcBrain.pushOperand(2.0)
        result = calcBrain.performOperation("÷")
        XCTAssertEqual(result!, 3.0, "Multiplication result invalid.")
        
        //Negation test
        calcBrain.clearOps()
        calcBrain.pushOperand(5)
        result = calcBrain.performOperation("+/-")
        XCTAssertEqual(result!, -5, "Negation result invalid.")
        result = calcBrain.performOperation("+/-")
        XCTAssertEqual(result!, 5.0, "Negation result invalid.")
        
    }
    
    func testAdvancedMathOps (){
        
        let calcBrain = CalculatorBrain()
        
        //Square root test
        calcBrain.pushOperand(4.0)
        var result = calcBrain.performOperation("√")
        XCTAssertEqual(result!, 2.0, "Square root result invalid.")
    
        //Sin test
        calcBrain.clearOps()
        calcBrain.pushOperand(30.0)
        result = calcBrain.performOperation("sin")
        XCTAssertEqualWithAccuracy(result!, 0.5, accuracy: 0.0000001, "sin result invalid.")
        
        //Cos test
        calcBrain.clearOps()
        calcBrain.pushOperand(60.0)
        result = calcBrain.performOperation("cos")
        XCTAssertEqualWithAccuracy(result!, 0.5, accuracy: 0.0000001, "cos result invalid.")

    }
    
    func testConstants (){
        
        let calcBrain = CalculatorBrain()
        
        //Pi
        let result = calcBrain.performOperation("π")
        XCTAssertEqual(result!, M_PI, "Pi result invalid.")
    }
    
    /*func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }*/

}
