//
//  ViewController.swift
//  HelloMLMac
//
//  Created by Martin Davy on 8/7/18.
//  Copyright © 2018 Martin Davy. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var imageCell: NSImageCell!
    
    var rawImages : [[UInt8]]?
    var columnCount : UInt32?
    var rowCount : UInt32?
    var imageCount : UInt32?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //let imageInfo = getImageInfoFromImage(image: NSImage(named: "MyImage")!)
        LoadMNistImages()
        guard let imageInfo = GetImageInfoFromMnistImage(index: 10) else { return }
        let image = imageFromImageInfo(imageInfo: imageInfo)
        
        imageCell.image = image
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    public struct ImageInfo
    {
        public struct PixelData {
            var a:UInt8 = 255
            var r:UInt8 = 0
            var g:UInt8 = 0
            var b:UInt8 = 0
        }
        let width : Int
        let height : Int
        let pixels: [PixelData]
    }
    
    private let pixelDataSize = MemoryLayout<ImageInfo.PixelData>.size
    private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    private let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
    
    private func LoadMNistImages()
    {
        guard let (ic, cc, rc, ri) = getRawTrainingImages() else { return }
        self.imageCount = ic
        self.columnCount = cc
        self.rowCount = rc
        self.rawImages = ri
    }
    
    private func GetImageInfoFromMnistImage(index: Int) -> ImageInfo?
    {
        guard let image = self.rawImages?[index] else { return nil }
        
        let rows = Int(self.rowCount!)
        let cols = Int(self.columnCount!)
        
        let convertPixel: (UInt8) -> ImageInfo.PixelData = { pixel in
            return ImageInfo.PixelData(a: 255, r:pixel, g:pixel, b:pixel)
        }
        
        let pixels = image.map(convertPixel)
        let imageInfo = ImageInfo(width: cols, height: rows, pixels: pixels)
        
        return imageInfo
    
    }
    
    public func imageFromImageInfo(imageInfo: ImageInfo) -> NSImage {
        
        let bitsPerComponent = 8
        let bitsPerPixel = 32
        
        assert(imageInfo.pixels.count == imageInfo.width * imageInfo.height)
        
        var data = imageInfo.pixels // Copy to mutable []
        let providerRef = CGDataProvider(
            data: NSData(bytes: &data, length: data.count * pixelDataSize)
        )
        
        let cgim = CGImage.init(
            width: imageInfo.width,
            height: imageInfo.height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: imageInfo.width * pixelDataSize ,
            space: rgbColorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef!,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent)
        
        return NSImage(cgImage: cgim!, size: NSSize(width: imageInfo.width, height:imageInfo.height))
    }
    
    public func createImageInfo(width: Int, height: Int, value:ImageInfo.PixelData) -> ImageInfo {
        let imageInfo = ImageInfo(width: width, height: height, pixels: Array(repeating:value, count: width*height))
        return imageInfo
    }
    
    public func getImageInfoFromImage(image : NSImage) -> ImageInfo {
    
        let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil)
        let provider = cgImage!.dataProvider
        let providerData = provider!.data
        let data = CFDataGetBytePtr(providerData)!
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        
        var pixels: [ImageInfo.PixelData] = []
        
        for y in 0..<height {
            for x in 0..<width {
                let pixelData = (width * y + x) * 4
                let r = data[pixelData]
                let g = data[pixelData + 1]
                let b = data[pixelData + 2]
                let a = data[pixelData + 3]
                pixels.append(ImageInfo.PixelData(a: a, r: r, g: g, b: b))
            }
        }
        
        return ImageInfo(width: width, height: height, pixels: pixels)
    }
    
    public func setPixels(width: Int, height: Int) -> ImageInfo {
        
        let red =  ImageInfo.PixelData(a: 255, r: 255, g: 0, b: 0)
        let white = ImageInfo.PixelData(a: 255, r: 255, g: 255, b: 255)
        let blue = ImageInfo.PixelData(a: 255, r: 0, g: 0, b: 255)
        let black = ImageInfo.PixelData(a: 255, r: 0, g: 0, b: 0)
        let colorSequence = [red, white, blue]
        
        var imageInfo = createImageInfo(width: width, height: height, value:black)
        var colorIndex = 0
        
        for y in 0..<height {
            for x in 0..<width {
                let index = colorIndex % colorSequence.count
                imageInfo = setPixel(imageInfo: imageInfo, x: x, y: y, value: colorSequence[index])
                colorIndex += 1
            }
        }
        
        return imageInfo
        
    }
    
    public func setPixel(imageInfo: ImageInfo, x: Int, y: Int, value:ImageInfo.PixelData) -> ImageInfo
    {
        let w = imageInfo.width
        let h = imageInfo.height
        
        guard x >= 0, y >= 0, x < w, y < h else {
            return imageInfo
        }
        
        var newPixels = imageInfo.pixels
        let i = w * y + x
        
        newPixels[i] = value
        
        return ImageInfo(width: w, height: h, pixels: newPixels)
    }

}

