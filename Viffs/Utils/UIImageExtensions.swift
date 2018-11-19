//
//  UIImageExtensions.swift
//  Viffs
//
//  Created by Robert Lorentz on 2018-11-15.
//  Copyright © 2018 Viffs. All rights reserved.
//

import Foundation

extension UIImage {
  func convertToGrayScale() -> UIImage {
    let filter: CIFilter = CIFilter(name: "CIPhotoEffectMono")!
    filter.setDefaults()
    filter.setValue(CoreImage.CIImage(image: self)!, forKey: kCIInputImageKey)
    
    return UIImage(cgImage: CIContext(options:nil).createCGImage(filter.outputImage!, from: filter.outputImage!.extent)!)
  }
  
  func convertToBlackAndWhite() -> UIImage {
    guard let currentCGImage = self.cgImage else { return self }
    let currentCIImage = CIImage(cgImage: currentCGImage)
    
    let filter = CIFilter(name: "CIColorMonochrome")
    filter?.setValue(currentCIImage, forKey: "inputImage")
    
    // set a gray value for the tint color
    filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")
    
    filter?.setValue(1.0, forKey: "inputIntensity")
    guard let outputImage = filter?.outputImage else { return self }
    
    let context = CIContext()
    
    if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
      let processedImage = UIImage(cgImage: cgimg)
      return processedImage
    }
    return self
  }
}
