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
  var apiService: APIService = .live
  var auth: Auth = Auth()
  var currentUser: User? = nil
  var currentAWSUser: AWSCognitoIdentityUser? = nil
  var pool: AWSCognitoIdentityUserPool? = nil
  var storeDict: [String : Store] = [:]
  var accessToken: String? = nil
  var stores: [Store] = []
  var offers: [Offer] = []
  var cards: [Card] = []
  
  //Tillfälligt!!
  var username: String? = nil
  var password: String? = nil
}

func flushEnvironment() {
  Current.currentUser = nil
}
