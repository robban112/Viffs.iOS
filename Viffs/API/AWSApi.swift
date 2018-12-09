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
import Overture

let baseAWSURL = "http://blipp-dev.eu-west-1.elasticbeanstalk.com/api"
let receiptAWSURL = baseAWSURL + "/receipts"
let storesAWSURL = baseAWSURL + "/stores"
let receiptImageURL = baseAWSURL + "/receiptimage"
let cardURL = baseAWSURL + "/cards"

let viffsDateFormatter = with(DateFormatter(), set(\.dateFormat, "yyyy-MM-dd'T'HH:mm:ss"))

func setReceipts(token: String) {
  firstly {
    AWSGetReceiptsForUser(token: token)
    }.done { receipts in

      //NOTE: Only update receipts when the total receipt length is different than current.
      if shouldUpdate(receipts: receipts) {
        Current.isLoadingReceipts = false
        Current.user = User(username: "", password: "", receipts: receipts)
        Current.receipts = receipts
        NotificationCenter.default.post(name: Notification.Name("ReceiptsSet"), object: nil)
      }
    }.catch { (error) in
      print(error)
  }
}

func shouldUpdate(receipts: [Receipt]) -> Bool {
  return Current.receipts.count != receipts.count || receipts.count == 1
}

func scheduleRefreshUserData(token: String) -> Timer {
  return Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
    if let accessToken = Current.accessToken {
      print("Refreshing user data...")
      setReceipts(token: accessToken)
      setCards(token: accessToken)
    }
  }
}

func setStores() {
  let store = Store(name: "Demobutik", pubID: "78c259ca-c59b-11e8-af09-027c671add7e", address: "Birger Jarlsgatan 29")
  Current.stores = [store]
}

func setCards(token: String) {
  firstly {
    AWSGetCards(token: token)
    }.done { cards in
      NotificationCenter.default.post(name: Notification.Name("CardsSet"), object: nil)
      Current.cards = cards
    }.catch { (error) in
      print("Unable to retrieve cards")
      print(error)
  }
}

func setOffers() {
  let offer = Offer.init(name: "Offer", picture: UIImage.init(named: "electronics")!)
  let offer2 = Offer.init(name: "Offer", picture: UIImage.init(named: "fashion")!)
  let offer3 = Offer.init(name: "Offer", picture: UIImage.init(named: "home")!)
  let offer4 = Offer.init(name: "Offer", picture: UIImage.init(named: "food_and_drinks")!)
  let offer5 = Offer.init(name: "Offer", picture: UIImage.init(named: "beauty")!)
  Current.offers = [offer, offer2, offer3, offer4, offer5]
}

func AWSGetReceiptsForUser(token: String) -> Promise<[Receipt]> {
  let headers = ["AccessToken": token]
  return Alamofire.request(receiptAWSURL, headers: headers)
    .validate()
    .responseJSON()
    .compactMap { json, _ in convertToReceipts(json: json) }
    .map { receipts in receipts.sorted(by: { $0.date > $1.date }) }
}

func convertToReceipts(json: Any) -> [Receipt]? {
  let dict = json as? [NSDictionary]
  return dict
    .map { $0.compactMap(parseResponseToReceipt) }
    .map { return $0.isEmpty
      ? [
        Receipt(
          currency: "SEK",
          name: "Demobutik",
          total: 9999,
          receiptPubID: "demo-mock",
          date: viffsDateFormatter.date(from: "2013-07-21T19:32:00")!,
          storePubID: "",
          cardPubID: "",
          userUploaded: false)
        ]
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

func parseResponseToReceipt(dict: NSDictionary) -> Receipt? {
  if let storePubID: String = dict["storePubID"] as? String,
    let receiptPubID: String = dict["pubID"] as? String,
    let total: Int64 = dict["price"] as? Int64,
    let dateStr: String = dict["date"] as? String,
    let date = viffsDateFormatter.date(from: String(dateStr.prefix(19))),
    let cardPubID: String = dict["cardPubID"] as? String,
    let userUploaded: Bool = dict["userUploaded"] as? Bool {
    let receipt = Receipt(
      currency: "SEK",
      name: "",
      total: Double(total),
      receiptPubID: receiptPubID,
      date: date,
      storePubID: storePubID,
      cardPubID: cardPubID,
      userUploaded: userUploaded
    )
    addToStoreDict(storePubID: storePubID)
    return receipt
  }
  print("FAIL")
  return nil
}

func getImage(for receipt: Receipt) -> Promise<UIImage> {
  Current.isLoadingReceiptDetail = true
  let headers = ["AccessToken": Current.accessToken ?? ""]
  //extreeeem fullösning
  guard receipt.receiptPubID != "demo-mock" else {
    NotificationCenter.default.post(name: Notification.Name("ReceiptImageSet"), object: nil)
    return Promise { $0.fulfill(UIImage(named: "demo_receipt")!) }
  }
  return Alamofire.request("\(receiptImageURL)/\(receipt.receiptPubID)", headers: headers)
    .responseData()
    .compactMap { data, _ in
      NotificationCenter.default.post(name: Notification.Name("ReceiptImageSet"), object: nil)
      return UIImage(data: data)
  }
}

func uploadImage(base64: String) {
  let headers = ["AccessToken": Current.accessToken ?? ""]
  let json: [String: Any] = [
    "ReceiptImageData": base64,
    "ReceiptImageMIME": "image/jpeg"
  ]
  Alamofire.request(
    receiptImageURL,
    method: .post,
    parameters: json,
    encoding: JSONEncoding.default,
    headers: headers
    )
    .responseData { (response: DataResponse) in
      switch response.result {
      case .success(let value):
        NotificationCenter.default.post(name: Notification.Name("UploadedImage"), object: nil)
        print("Successfully posted receipt")
        print(value)
      case .failure(let value):
        print("failed to post receipt")
        print(response.result)
        print(value)
      }
    }
}

/*
 * Receipt code has to be posted first, and then the card
 */
func postReceiptCodeAndCard(code: String, cardNumber: String) {
  let headers = ["AccessToken": Current.accessToken ?? "",
                 "Content-Type": "application/json"]
  let json: [ String: Any] = [
    "RegCode": code,
    "CardNumber": cardNumber
  ]

  Alamofire
    .request(
      cardURL,
      method: .post,
      parameters: json,
      encoding: JSONEncoding.default,
      headers: headers
    )
    .responseData { (response: DataResponse) in
      switch response.result {
      case .success(let value):
        if let accessToken = Current.accessToken {
          setReceipts(token: accessToken)
        }
        print("Successfully posted receipt code")
        print(value)
      case .failure(let value):
        print("failed to post receipt code")
        print(response.result)
        print(value)
      }
  }
}

func postCard(receiptCode: String, cardNumber: String) {
  let headers = ["AccessToken": Current.accessToken ?? "",
                 "Content-Type": "application/json"]
  let parameters: [ String: Any] = [
    "RegCode": receiptCode, "CardNumber": cardNumber
  ]
  
  Alamofire
    .request(
      cardURL,
      method: .post,
      parameters: parameters,
      encoding: JSONEncoding.default,
      headers: headers
    )
    .responseData { (response: DataResponse) in
      switch response.result {
      case .success(let value):
        print("Successfully added card")
        print(value)
      case .failure(let value):
        print("Failed to add card")
        print(response.result)
        print(value)
      }
  }
}

//OLD
func postReceiptCode(code: String) {
  let headers = ["AccessToken": Current.accessToken ?? "",
                 "Content-Type": "application/json"]
  let json: [ String: Any] = [
    "RegCode": code
  ]
  
  Alamofire
    .request(
      cardURL,
      method: .post,
      parameters: json,
      encoding: JSONEncoding.default,
      headers: headers
    )
    .responseData { (response: DataResponse) in
      switch response.result {
      case .success(let value):
        if let accessToken = Current.accessToken {
          setReceipts(token: accessToken)
        }
        print("Successfully posted receipt code")
        print(value)
      case .failure(let value):
        print("failed to post receipt code")
        print(response.result)
        print(value)
      }
  }
}

func AWSGetCards(token: String) -> Promise<[Card]> {
  let headers = ["AccessToken": token, "Content-Type": "application/json"]

  let req = Alamofire.request("\(cardURL)", headers: headers)
    .responseJSON()
    .compactMap { json, _ in
      return parseJsonToCards(json: json)
  }
  req.catch({ (error) in
    print("Failed to get cards from server")
    print(error)
  })
  return req
}

func parseJsonToCards(json: Any) -> [Card]? {
  let json = json as? [NSDictionary]
  return json
    .map { $0.compactMap(parseJsonToCard) }
}

func parseJsonToCard(json: Any) -> Card? {
  guard let json = json as? NSDictionary else {
    print("failed to parse card json to NSDictionary")
    return nil
  }
  if let cardNumber = json["cardNumber"] as? String, let pubID = json["pubID"] as? String {
    if let type = CardUtils.cardNumberToType(cardNumber: cardNumber) {
      if let image = CardUtils.cardTypeToImage(cardType: type) {
        return Card.init(number: cardNumber, cardType: type, pubID: pubID, image: image)
      }
    } else {
      let image = UIImage(named: "question_mark")!
      let type = "Okänd"
      return Card.init(number: cardNumber, cardType: type, pubID: pubID, image: image)
    }
  }
  return nil
}
