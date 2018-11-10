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
    var biases = [[Float]]()
    var weights = [[[Float]]]()
    
    init(sizes: [Int]) {
        
        self.layers = sizes.count
        self.sizes = sizes
        
        for i in 1..<self.layers {
            biases.append(initBiases(size: sizes[i]))
            weights.append(initWeights(dims: (sizes[i-1], sizes[i])))
        }
    }
    
    func sigmoid(value: Double) -> Double {
        return 1.0 / (1.0 + pow(M_E, -value))
    }
    
    func initWeights(dims: (Int, Int)) -> [[Float]] {
        
        var weights = [[Float]]()
        for _ in 1...dims.1 {
            let row = (1...dims.0).map {_ in Float.random(in: 0.0...1.0)}
            weights.append(row)
        }
        return weights
    }
    
    func initBiases(size: Int) -> [Float] {
      
        let bias = (1...size).map {_ in Float.random(in: 0.0...1.0)}
        
        return bias
    }
}
