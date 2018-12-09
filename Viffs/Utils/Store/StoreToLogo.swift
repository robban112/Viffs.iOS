//
//  StoreToLogo.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-08-21.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import UIKit

var storeToLogo: [String: String] = [
    "Hemköp": "hemkop_logo.png",
    "Pressbyrån": "pressbyran_logo.png",
    "ICA": "ica_logo.png",
    "Willys": "willys_logo.png",
    "7-Eleven": "7-eleven_logo.png",
    "EasyPark": "easypark_logo.png",
    "Demobutik": "Viffs_ikon.png"
]

var storeToImage: [String: UIImage] = [
  "Demobutik": UIImage(named: "Viffs_ikon.png")!
]

var cardTypeToImage: [String: UIImage] = [
  "MasterCard": UIImage(named: "mastercard_logo")!,
  "Visa": UIImage(named: "visa_logo")!
]
