//
//  Environment.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-06.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import Firebase

var Current = Environment()

struct Environment {
  let auth: Auth
  let currentUser: User?
  
  init(
    auth: Auth = Auth.auth(),
    currentUser: User? = nil
    ) {
    self.auth = auth
    self.currentUser = currentUser
  }
}
