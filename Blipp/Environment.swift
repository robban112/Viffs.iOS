//
//  Environment.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-06.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import FirebaseAuth

var Current = Environment()

struct Environment {
  let apiService: APIService
  let currentUser: User?
  
  init(
    apiService: APIService = APIService.live,
    currentUser: User? = nil
    ) {
    self.apiService = apiService
    self.currentUser = currentUser
  }
}
