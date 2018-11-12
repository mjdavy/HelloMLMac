//
//  Network.swift
//  HelloMLMac
//
//  Created by Martin Davy on 11/7/18.
//  Copyright © 2018 Martin Davy. All rights reserved.
//

import Foundation

public class Network {
    
    let layers: Int
    let sizes: [Int]
    var biases = [[Double]]()
    var weights = [[[Double]]]()
    
    init(sizes: [Int])
    {
        self.layers = sizes.count
        self.sizes = sizes
        
        for i in 1..<self.layers
        {
            biases.append(Network.initBiases(size: sizes[i]))
            weights.append(Network.initWeights(dims: (sizes[i-1], sizes[i])))
        }
    }
    
    class func sigmoid(value: Double) -> Double
    {
        return 1.0 / (1.0 + pow(M_E, -value))
    }
    
    static func initWeights(dims: (Int, Int)) -> [[Double]]
    {
        var weights = [[Double]]()
        for _ in 1...dims.1 {
            let row = (1...dims.0).map {_ in Double.random(in: 0.0...1.0)}
            weights.append(row)
        }
        return weights
    }
    
    static func initBiases(size: Int) -> [Double]
    {
        let bias = (1...size).map {_ in Double.random(in: 0.0...1.0)}
        return bias
    }
    
    static func feedOne(input: [Double], weights: [Double], bias:Double) -> Double
    {
        assert(input.count == weights.count)
        let val = zip(input,weights).map {$0.0 * $0.1}.reduce(0, +) + bias
        return Network.sigmoid(value: val)
    }
    
    static func cost(actual: [Double], correct:[Double]) -> Double
    {
        assert(actual.count == correct.count)
        let cost = zip(actual,correct).map {pow(($0.0 - $0.1),2)}.reduce(0,+)
        return Double(cost)
    }
    
    static func oneHot(digit: Int) -> [Double]
    {
        var result : [Double] = Array(repeating: 0.0, count: 10)
        guard (0...9).contains(digit) else { return result }
        result[digit] = 1.0
        return result
    }
    
    func feedForward(input: [Double], layer: Int) -> [Double]
    {
        if layer == layers - 1 {
            return input
        }
        
        assert(input.count == sizes[layer])
        
        let weights = self.weights[layer]
        let biases = self.biases[layer]
        var activation = [Double]()
        
        for i in 0..<weights.count
        {
            let value = Network.feedOne(input: input, weights: weights[i], bias: biases[i])
            activation.append(value)
        }
        
        return feedForward(input: activation, layer: layer+1)
    }
}
