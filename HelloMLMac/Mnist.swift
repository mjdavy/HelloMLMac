//
//  Mnist.swift
//  HelloMLMac
//
//  Created by Martin Davy on 10/29/18.
//  Copyright © 2018 Martin Davy. All rights reserved.
//

import Foundation

enum DataFileType {
    case Image
    case Label
}

func getRawTrainingImages() -> (UInt32, UInt32, UInt32, [[UInt8]]?)?
{
    let mainBundle = Bundle.main
    guard
        let trainImagesPath = mainBundle.path(forResource: "train-images-idx3-ubyte", ofType: nil),
        let trainImageData = NSData(contentsOfFile: trainImagesPath),
        let (magic, imageCount, columnCount, rowCount) = readImageFileHeader(data: trainImageData)
        else { return nil }
    assert(magic == 2051)
    let rawImages = rawImageData(data: trainImageData, imageCount: imageCount, columnCount: columnCount, rowCount: rowCount)
    return (imageCount, columnCount, rowCount, rawImages)
}

func loadData() -> ([[Float]], [Int], [[Float]], [Int])? {
    let mainBundle = Bundle.main
    guard
        let trainImagesPath = mainBundle.path(forResource: "train-images-idx3-ubyte", ofType: nil),
        let trainImageData = NSData(contentsOfFile: trainImagesPath),
        let testImagesPath = mainBundle.path(forResource: "t10k-images-idx3-ubyte", ofType: nil),
        let testImageData = NSData(contentsOfFile: testImagesPath),
        let trainLabelsPath = mainBundle.path(forResource: "train-labels-idx1-ubyte", ofType: nil),
        let trainLabelData = NSData(contentsOfFile: trainLabelsPath),
        let testLabelsPath = mainBundle.path(forResource: "t10k-labels-idx1-ubyte", ofType: nil),
        let testLabelData = NSData(contentsOfFile: testLabelsPath),
        let trainImages = imageData(data: trainImageData),
        let testImages = imageData(data: testImageData),
        let trainLabels = labelData(data: trainLabelData),
        let testLabels = labelData(data: testLabelData) else { return nil }
    
    return (trainImages, trainLabels, testImages, testLabels)
}

func labelData(data: NSData) -> [Int]? {
    let (_, nItem) = readLabelFileHeader(data: data)
    
    let range = 0..<Int(nItem)
    let extractLabelClosure: (Int) -> UInt8 = { itemIndex in
        return extractLabel(data: data, labelIndex: itemIndex)
    }
    
    return range.map(extractLabelClosure).map(Int.init)
}

func rawImageData(data: NSData, imageCount: UInt32, columnCount: UInt32, rowCount: UInt32) -> [[UInt8]]? {
   
    let imageLength = Int(columnCount * rowCount)
    let range = 0..<Int(imageCount)
    let extractImageClosure: (Int) -> [UInt8] = { itemIndex in
        return extractImage(data: data, pixelCount: imageLength, imageIndex: itemIndex)
            .map({$0})
    }
    
    return range.map(extractImageClosure)
}

func imageData(data: NSData) -> [[Float]]? {
    guard let (_, nItem, nCol, nRow) = readImageFileHeader(data: data) else { return nil }
    
    let imageLength = Int(nCol * nRow)
    let range = 0..<Int(nItem)
    let extractImageClosure: (Int) -> [Float] = { itemIndex in
        return extractImage(data: data, pixelCount: imageLength, imageIndex: itemIndex)
            .map({Float($0)/255})
    }
    
    return range.map(extractImageClosure)
}

func extractImage(data: NSData, pixelCount: Int, imageIndex: Int) -> [UInt8] {
    var byteArray = [UInt8](repeating: 0, count: pixelCount)
    data.getBytes(&byteArray, range: NSRange(location: 16 + imageIndex * pixelCount, length: pixelCount))
    return byteArray
}

func extractLabel(data: NSData, labelIndex: Int) -> UInt8 {
    var byte: UInt8 = 0
    data.getBytes(&byte, range: NSRange(location: 8 + labelIndex, length: 1))
    return byte
}

func readImageFileHeader(data: NSData) -> (UInt32, UInt32, UInt32, UInt32)? {
    let header = readHeader(data: data, dataType: .Image)
    guard let col = header.2, let row = header.3 else { return nil }
    return (header.0, header.1, col, row)
}

func readLabelFileHeader(data: NSData) -> (UInt32, UInt32) {
    let header = readHeader(data: data, dataType: .Label)
    return (header.0, header.1)
}


func readHeader(data: NSData, dataType: DataFileType) -> (UInt32, UInt32, UInt32?, UInt32?) {
    switch dataType {
    case .Image:
        let headerValues = data.bigEndianInt32s(range: (0..<4))
        return (headerValues[0], headerValues[1], headerValues[2], headerValues[3])
    case .Label:
        let headerValues = data.bigEndianInt32s(range: (0..<2))
        return (headerValues[0], headerValues[1], nil, nil)
    }
}

extension NSData {
    func bigEndianInt32(location: Int) -> UInt32? {
        var value: UInt32 = 0
        self.getBytes(&value, range: NSRange(location: location, length: MemoryLayout<UInt32>.size))
        return UInt32(bigEndian: value)
    }
    
    func bigEndianInt32s(range: Range<Int>) -> [UInt32] {
        return range.compactMap({bigEndianInt32(location: $0 * MemoryLayout<UInt32>.size)})
    }
}
