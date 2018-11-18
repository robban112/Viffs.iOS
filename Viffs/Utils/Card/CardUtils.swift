//
//  CardUtils.swift
//  Viffs
//
//  Created by Robert Lorentz on 2018-11-18.
//  Copyright © 2018 Viffs. All rights reserved.
//

import Foundation


class CardUtils {
  
  static let prefixToType: [ Int : String ] = [
    4 : "Visa",
    51 : "MasterCard",
    52 : "MasterCard",
    53 : "MasterCard",
    54 : "MasterCard",
    55 : "MasterCard",
    34 : "American Express",
    37 : "American Express",
    5018 : "Maestro",
    5020 : "Maestro",
    5038 : "Maestro",
    5612 : "Maestro",
    5893 : "Maestro",
    6304 : "Maestro",
    6759 : "Maestro",
    6761 : "Maestro",
    6762 : "Maestro",
    6763 : "Maestro",
    0604 : "Maestro",
    6390 : "Maestro"
  ]
  
  static let typeToImage: [ String : UIImage ] = [
    "Visa" : UIImage(named: "visa_logo")!,
    "MasterCard" : UIImage(named: "mastercard_logo")!
  ]
  
  static func cardNumberToType(cardNumber: String) -> String? {
    if let first = Int(cardNumber.prefix(1)), let two = Int(cardNumber.prefix(2)),
      let four = Int(cardNumber.prefix(4)) {
      
      if let holderFirstNum = prefixToType[first] {
        return holderFirstNum
      }
      if let holderTwoNum = prefixToType[two] {
        return holderTwoNum
      }
      if let holderFourNum = prefixToType[four] {
       return holderFourNum
      }
    }
    print("Failed to parse cardnumber \(cardNumber) to cardholder")
    return nil
    }
  
  static func cardTypeToImage(cardType: String) -> UIImage? {
    if let image = typeToImage[cardType] {
      return image
    } else {
      print("Failed to parse cardType \(cardType) to an image")
      return nil
    }
  }
}
