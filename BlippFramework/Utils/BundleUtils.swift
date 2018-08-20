//
//  BundleUtils.swift
//  BlippFramework
//
//  Created by Oskar Ek on 2018-08-20.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit

class BundleDummy {}

struct BundledImage: _ExpressibleByImageLiteral {
  let image: UIImage?
  
  init(imageLiteralResourceName name: String) {
    let bundle = Bundle(for: BundleDummy.self)
    image = UIImage(named: name, in: bundle, compatibleWith: nil)
  }
}

extension UIImage {
  static func bundledImage(_ bundledImage: BundledImage) -> UIImage? {
    return bundledImage.image
  }
}
