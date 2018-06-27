//
//  User.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-05-29.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation

struct User: Decodable {
  let username: String
  let password: String
  let receipts: [Receipt]
}

