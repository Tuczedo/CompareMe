//
//  RGBA.swift
//  Envisage
//
//  Created by iD Student on 6/27/16.
//  Copyright © 2016 iD Student. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

struct RGBA {
    var pixels: UnsafeMutableBufferPointer<Pixel>
    var width: Int
    var height: Int
    
    init? (image: UIImage) {
        guard let cgImage = image.CGImage else { return nil } // 1
        
        width = Int(image.size.width)
        height = Int(image.size.height)
        let bitsPerComponent = 8 // 2
        
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let imageData = UnsafeMutablePointer<Pixel>.alloc(width * height)
        let colorSpace = CGColorSpaceCreateDeviceRGB() // 3
        
        var bitmapInfo: UInt32 = CGBitmapInfo.ByteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.PremultipliedLast.rawValue & CGBitmapInfo.AlphaInfoMask.rawValue
        guard let imageContext = CGBitmapContextCreate(imageData, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo) else { return nil }
        CGContextDrawImage(imageContext, CGRect(origin: CGPointZero, size: image.size), cgImage) // 4
        
        pixels = UnsafeMutableBufferPointer<Pixel>(start: imageData, count: width * height)
    }
    
    func toUIImage() -> UIImage? {
        let bitsPerComponent = 8 // 1
        
        let bytesPerPixel = 4
        let bytesPerRow = width * bytesPerPixel
        let colorSpace = CGColorSpaceCreateDeviceRGB() // 2
        
        var bitmapInfo: UInt32 = CGBitmapInfo.ByteOrder32Big.rawValue
        bitmapInfo |= CGImageAlphaInfo.PremultipliedLast.rawValue & CGBitmapInfo.AlphaInfoMask.rawValue
        let imageContext = CGBitmapContextCreateWithData(pixels.baseAddress, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo, nil, nil)
        guard let cgImage = CGBitmapContextCreateImage(imageContext) else {return nil} // 3
        
        let image = UIImage(CGImage: cgImage)
        return image
        
    }
}
