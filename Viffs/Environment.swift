//
//  Environment.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-06.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider

// swiftlint:disable identifier_name
var Current = Environment()

struct Environment {
  var user: User?
  var loginManager: AWSLoginManager = AWSLoginManager()
  var AWSUser: AWSCognitoIdentityUser?
  var pool: AWSCognitoIdentityUserPool?
  var storeDict: [String: Store] = [:]
  var accessToken: String?
  var receipts: [Receipt] = []
  var stores: [Store] = []
  var offers: [Offer] = []
  var cards: [Card] = []
  var timer: Timer?
  var isLoadingReceipts: Bool = true
  var isLoadingReceiptDetail: Bool = true

  //Tillfälligt!! Andvänds vid reg processen
  var username: String?
  var password: String?
  var receiptCode: String?
  var cardNumber: String?
}

func flushEnvironment() {
  Current = .init()
}
