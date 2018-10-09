//
//  Environment.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-06.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import FirebaseAuth
import AWSCognitoIdentityProvider


var Current = Environment()

struct Environment {
  private(set) var apiService: APIService = .live
  private(set) var auth: Auth = Auth()
  var currentUser: User? = nil
  var currentAWSUser: AWSCognitoIdentityUser? = nil
  var pool: AWSCognitoIdentityUserPool? = nil
  var storeDict: [String : Store] = [:]
  var accessToken: String? = nil
  
  //Tillfälligt!!
  var username: String? = nil
  var password: String? = nil
}
