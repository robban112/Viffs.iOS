//
//  Environment.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-06.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider


var Current = Environment()

struct Environment {
  var currentUser: User? = nil
  var currentAWSUser: AWSCognitoIdentityUser? = nil
  var pool: AWSCognitoIdentityUserPool? = nil
  var storeDict: [String : Store] = [:]
  var accessToken: String? = nil
  var receipts: [Receipt] = []
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
