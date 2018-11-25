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
  var user: User? = nil
  var AWSUser: AWSCognitoIdentityUser? = nil
  var pool: AWSCognitoIdentityUserPool? = nil
  var storeDict: [String : Store] = [:]
  var accessToken: String? = nil
  var receipts: [Receipt] = []
  var stores: [Store] = []
  var offers: [Offer] = []
  var cards: [Card] = []
  var timer: Timer? = nil
  var isLoadingReceipts: Bool = true
  var isLoadingReceiptDetail: Bool = true
  
  //Tillfälligt!! Andvänds vid reg processen
  var username: String? = nil
  var password: String? = nil
  var receiptCode: String? = nil
  var cardNumber: String? = nil
}

func flushEnvironment() {
  Current = .init()
}
