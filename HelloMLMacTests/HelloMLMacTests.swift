//
//  HelloMLMacTests.swift
//  HelloMLMacTests
//
//  Created by Martin Davy on 8/7/18.
//  Copyright © 2018 Martin Davy. All rights reserved.
//

import XCTest
@testable import HelloMLMac

class HelloMLMacTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testAnotherExample() {
        XCTAssert(true)
    }
    
    func testBiasDims() {
         let n = Network(sizes: [2,3,4])
        
         XCTAssert(n.layers == 3)
        
         XCTAssert(n.biases.count == 2)
         XCTAssert(n.biases[0].count == 3)
         XCTAssert(n.biases[1].count == 4)
        
         XCTAssert(n.weights.count == 2)
         XCTAssert(n.weights[0].count == 3)
         XCTAssert(n.weights[1].count == 4)
        
         XCTAssert(n.weights[0][0].count == 2)
         XCTAssert(n.weights[0][1].count == 2)
         XCTAssert(n.weights[0][2].count == 2)
        
         XCTAssert(n.weights[1][0].count == 3)
         XCTAssert(n.weights[1][1].count == 3)
         XCTAssert(n.weights[1][2].count == 3)
         XCTAssert(n.weights[1][3].count == 3)
    }
    
    func testSigmoid() {
        let n = Network(sizes: [0,0,0])
        for i in -10...10 {
            let x = n.sigmoid(value: Double(i))
            XCTAssert(x >= 0.0)
            XCTAssert(x <= 1.0)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
