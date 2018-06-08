//
//  ReceiptViewModel.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-06.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ReceiptViewModelInputs {

}

protocol ReceiptViewModelOutputs {
  var receipts: Driver<[Receipt]> { get }
}

protocol ReceiptViewModelType {
  var inputs: ReceiptViewModelInputs { get }
  var outputs: ReceiptViewModelOutputs { get }
}

struct ReceiptViewModel: ReceiptViewModelType, ReceiptViewModelInputs, ReceiptViewModelOutputs {
  let receipts: Driver<[Receipt]>
  
  init() {
    receipts = Driver.just([ Receipt(name: "Pressbyrån", total: "30", url: "")
                           , Receipt(name: "ICA", total: "200", url: "") ])
  }
  
  var inputs: ReceiptViewModelInputs { return self }
  var outputs: ReceiptViewModelOutputs { return self }
}
