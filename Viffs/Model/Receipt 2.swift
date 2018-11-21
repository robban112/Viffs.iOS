//
//  Receipt.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-05-15.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import UIKit

struct Receipt: Decodable {
  let currency: String
  var name: String
  let total: Double
  let receiptPubID: String
  let date: String
  let storePubID: String
  let cardPubID: String
  let userUploaded: Bool
}
