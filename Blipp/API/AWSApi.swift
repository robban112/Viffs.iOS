	//
//  AWSApi.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-09-18.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit
import RxSwift

let baseAWSURL = "http://blipp-dev.eu-west-1.elasticbeanstalk.com/api"
let receiptAWSURL = baseAWSURL + "/receipts"
let storesAWSURL = baseAWSURL + "/stores"
let receiptImageURL = baseAWSURL + "/receiptimage"

func setReceiptsForUser(token: String) {
  firstly {
    AWSGetReceiptsForUser(token: token)
  }.done { receipts in
    Current.currentUser = User(username: "", password: "", receipts: receipts)
    NotificationCenter.default.post(name: Notification.Name("ReceiptsSet"), object: nil)
  }
}
func AWSGetReceiptsForUser(token: String) -> Promise<[Receipt]> {
  let headers = ["AccessToken" : token]
  return Alamofire.request(receiptAWSURL, headers: headers)
    .validate()
    .responseJSON()
    .compactMap { json, _ in convertToReceipts(json: json) }
}

func convertToReceipts(json: Any) -> [Receipt]? {
  return (json as? [NSDictionary])
    .map { $0.compactMap(parseResponseToReceipt) }
}

func convertToStore(json: Any) -> Store? {
  if let json = json as? NSDictionary {
    if let name = json["name"] as? String, let logoURL = json["logoURL"] as? String,
      let pubID = json["pubID"] as? String {
      return Store(name: name, logoURL: logoURL, pubID: pubID)
    }
  }
  return nil
}

func AWSGetStoreForPubID(storePubID: String) -> Promise<Store> {
  return Alamofire.request("\(storesAWSURL)/\(storePubID)")
    .responseJSON()
    .compactMap { json, _ in convertToStore(json: json) }
}

func addToStoreDict(storePubID: String) {
  if Current.storeDict["storePubID"] == nil {
    AWSGetStoreForPubID(storePubID: storePubID).done { store in
      Current.storeDict[storePubID] = store
      NotificationCenter.default.post(name: Notification.Name("StoreAdded"), object: nil)
    }
  }
}

//func AWSGetReceiptImage(receiptPubID: String) -> Promise<

func parseResponseToReceipt(dict: NSDictionary) -> Receipt? {
  if let storePubID: String = dict["storePubID"] as? String,
    let receiptPubID: String = dict["pubID"] as? String,
    let total: Int64 = dict["price"] as? Int64,
    let date: String = dict["date"] as? String {
    var receipt = Receipt(currency: "SEK", name: "", total: Double(total), receiptPubID: receiptPubID, date: date, storePubID: storePubID)
    addToStoreDict(storePubID: storePubID)
    return receipt
  }
  return nil
}

  func getImage(for receipt: Receipt) -> Promise<UIImage> {
    let headers = ["AccessToken" : Current.accessToken ?? ""]
    return Alamofire.request("\(receiptImageURL)/\(receipt.receiptPubID)", headers: headers)
      .responseData()
      .compactMap { data, _ in
        return UIImage(data: data)
      }
  }
