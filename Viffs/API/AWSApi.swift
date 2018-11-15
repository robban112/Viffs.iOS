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
let cardURL = baseAWSURL + "/cards"

func setReceiptsForUser(token: String) {
  firstly {
    AWSGetReceiptsForUser(token: token)
  }.done { receipts in
    //FIX: Remove receipts from currentUser.
    let rev: [Receipt] = receipts.reversed()
    Current.user = User(username: "", password: "", receipts: rev)
    Current.receipts = receipts
    NotificationCenter.default.post(name: Notification.Name("ReceiptsSet"), object: nil)
    }.catch { (error) in
      print(error)
    }
}
  
func setStores() {
  let store = Store.init(name: "Demobutik", pubID: "78c259ca-c59b-11e8-af09-027c671add7e", address: "Birger Jarlsgatan 29")
  Current.stores = [store]
}
  
func setCards() {
  let card = Card.init(date: "05/20", number: "1234567812345678", cardType: "MasterCard")
  let card2 = Card.init(date: "05/20", number: "1234567812345678", cardType: "MasterCard")
  let card3 = Card.init(date: "05/20", number: "1234567812345678", cardType: "Visa")
  Current.cards = [card, card2, card3]
}
  
func setOffers() {
  let offer = Offer.init(name: "Offer", picture: UIImage.init(named: "KvittoIkon")!)
  let offer2 = Offer.init(name: "Offer", picture: UIImage.init(named: "KvittoIkon")!)
  let offer3 = Offer.init(name: "Offer", picture: UIImage.init(named: "KvittoIkon")!)
  let offer4 = Offer.init(name: "Offer", picture: UIImage.init(named: "KvittoIkon")!)
  let offer5 = Offer.init(name: "Offer", picture: UIImage.init(named: "KvittoIkon")!)
  let offer6 = Offer.init(name: "Offer", picture: UIImage.init(named: "KvittoIkon")!)
  let offer7 = Offer.init(name: "Offer", picture: UIImage.init(named: "KvittoIkon")!)
  Current.offers = [offer, offer2, offer3, offer4, offer5, offer6, offer7]
}
  
func AWSGetReceiptsForUser(token: String) -> Promise<[Receipt]> {
  let headers = ["AccessToken" : token]
  return Alamofire.request(receiptAWSURL, headers: headers)
    .validate()
    .responseJSON()
    .compactMap { json, _ in convertToReceipts(json: json) }
}

  func convertToReceipts(json: Any) -> [Receipt]? {
    let d = json as? [NSDictionary]
    return (json as? [NSDictionary])
      .map { $0.compactMap(parseResponseToReceipt) }
      .map { return $0.isEmpty
        ? [Receipt(currency: "SEK", name: "Demobutik", total: 9999, receiptPubID: "", date: "2017-03-08", storePubID: "")]
        : $0
        
    }
  }

func convertToStore(json: Any) -> Store? {
  if let json = json as? NSDictionary {
    if let name = json["name"] as? String, let pubID = json["pubID"] as? String,
      let address = json["address"] as? String {
      return Store(name: name, pubID: pubID, address: address)
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
      }.catch { (error) in
        print("Error at addToStoreDict()")
        print(error)
    }
  }
}

//func AWSGetReceiptImage(receiptPubID: String) -> Promise<

func parseResponseToReceipt(dict: NSDictionary) -> Receipt? {
  if let storePubID: String = dict["storePubID"] as? String,
    let receiptPubID: String = dict["pubID"] as? String,
    let total: Int64 = dict["price"] as? Int64,
    let date: String = dict["date"] as? String {
    let receipt = Receipt(currency: "SEK", name: "", total: Double(total), receiptPubID: receiptPubID, date: date, storePubID: storePubID)
    addToStoreDict(storePubID: storePubID)
    return receipt
  }
  return nil
}

  func getImage(for receipt: Receipt) -> Promise<UIImage> {
    let headers = ["AccessToken" : Current.accessToken ?? ""]
    return Alamofire.request("\(receiptImageURL)/\(receipt.receiptPubID)", headers: headers)
      .responseData()
      .compactMap { data, response in
        
        return UIImage(data: data)
      }
  }
    
  func uploadImage(base64: String) {
    let headers = ["AccessToken" : Current.accessToken ?? ""]
    let json: [String : Any] = [
      "ReceiptImageData" : base64,
      "ReceiptImageMIME" : "image/jpeg"
    ]
    Alamofire.request(receiptImageURL, method: .post, parameters: json, encoding: JSONEncoding.default, headers: headers).responseData
      { (response:DataResponse) in
        switch(response.result)
        {
        case .success(let value):
          print("----------------\nsuccessfully posted receipt\n--------------------")
          print(value)
        case .failure(let value):
          print("failed to post receipt")
          print(response.result)
          print(value)
    }
  }
}
  
  func postReceiptCode(code: String) {
    let headers = ["AccessToken" : Current.accessToken ?? "",
                   "Content-Type" : "application/json"]
    let json: [ String : Any] = [
      "RegCode": code
    ]
    Alamofire.request(cardURL, method: .post, parameters: json, encoding: JSONEncoding.default, headers: headers).responseData
      { (response:DataResponse) in
        switch(response.result)
        {
        case .success(let value):
          print("----------------successfully posted receipt code--------------------")
          print(value)
        case .failure(let value):
          print("failed to post receipt code")
          print(response.result)
          print(value)
        }
    }
  }

