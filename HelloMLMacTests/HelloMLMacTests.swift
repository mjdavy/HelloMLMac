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
        for i in -10...10 {
            let x = Network.sigmoid(value: Double(i))
            XCTAssert(x >= 0.0)
            XCTAssert(x <= 1.0)
        }
    }
    
    func test1Layer()
    {
        testNLayers(sizes: [4])
    }
    
    func test2Layers()
    {
        testNLayers(sizes: [4,5])
    }
    
    func test3Layers()
    {
        testNLayers(sizes: [4,5,10])
    }
    
    func test4Layers()
    {
        testNLayers(sizes: [784,16,16,10])
    }
    
    func testCost()
    {
        let correct = [0.0, 0.0, 1.0, 0.0]
        let actual = [0.3, 0.0, 0.8, 0.4]
        let result = Network.cost(actual: actual, correct: correct)
        let err = abs(result - 0.29)
        XCTAssert(err < 0.0000000000000001)
    }
    
    func testOneHot()
    {
        let v0 = Network.oneHot(digit: 0)
        XCTAssert(v0[0] == Double(1))
        
        let v9 = Network.oneHot(digit: 9)
        XCTAssert(v9[9] == Double(1))
        
        let v7 = Network.oneHot(digit: 7)
        XCTAssert(v7[7] == Double(1))
    }
    
    func testPerformanceExample()
    {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testNLayers(sizes: [Int])
    {
        let n = Network(sizes: sizes)
        let input = (1...sizes[0]).map {_ in Double.random(in: 0.0...1.0)}
        let output = n.feedForward(input: input, layer: 0)
        let outputSize = sizes[sizes.count - 1]
        XCTAssert(output.count == outputSize)
        let validValues = output.filter { $0 >= 0.0 && $0 <= 1.0 }
        XCTAssert(validValues.count == outputSize)
    }
    
}
