//
//  Receipt.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-05-15.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation

public struct Receipt: Decodable {
  let currency: String
  let name: String
  let total: Double
  let url: String
}
