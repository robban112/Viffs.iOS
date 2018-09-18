//
//  AWSApi.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-09-18.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import Alamofire

let baseAWSURL = "http://blipp-dev.eu-west-1.elasticbeanstalk.com/api"
let receiptAWSURL = baseAWSURL + "/receipts"
let storesSuffixURL = baseAWSURL + "/stores"

func AWSGetReceiptsForUser(token: String) {
  let headers = ["AccessToken" : token]
  Alamofire.request(receiptAWSURL, headers: headers).responseJSON { response in
    print(response)
    //to get status code
    if let status = response.response?.statusCode {
      switch(status){
      case 201:
        print("success - HTTP Created \(status)")
      case 200:
        print("success - HTTP OK \(status)")
      default:
        print("error with response status: \(status)")
      }
    }
    //to get JSON return value
    if let result = response.result.value {
      let receiptList = result as! NSArray
      let JSON = receiptList[0] as! NSDictionary
      print(JSON)
    }
    
  }
}
