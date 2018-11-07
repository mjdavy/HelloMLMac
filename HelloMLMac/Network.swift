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
    var biases: [[Float]]
    var weights: [[[Float]]]
    
    init(sizes: [Int]) {
        
        self.layers = sizes.count
        self.sizes = sizes
        self.biases = [[Float]]()
        self.weights = [[[Float]]]()
        
        for i in 0..<self.layers-1 {
            self.biases.append([Float](repeating: 0.0, count: self.sizes[i]))
            self.weights.append([[Float]]())
            for j in 0 ..< self.sizes[i] {
                self.biases[i][j] = Float.random(in:0.0...1.0)
                self.weights[i][j] = [Float]()
            }
        }
    }
    
}
