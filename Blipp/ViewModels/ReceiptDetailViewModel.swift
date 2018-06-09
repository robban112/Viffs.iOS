//
//  ReceiptDetailViewModel.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-09.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Overture

protocol ReceiptDetailViewModelInputs {
  var backButtonPressed: PublishSubject<()> { get }
}

protocol ReceiptDetailViewModelOutputs {
  var receipt: Single<Receipt> { get }
  var receiptImage: Single<UIImage?> { get }
}

protocol ReceiptDetailViewNavigationHandler {
  var backNavigation: Observable<()> { get }
}

protocol ReceiptDetailViewModelType {
  var inputs: ReceiptDetailViewModelInputs { get }
  var outputs: ReceiptDetailViewModelOutputs { get }
  var navigation: ReceiptDetailViewNavigationHandler { get }
}

struct ReceiptDetailViewModel: ReceiptDetailViewModelType
                             , ReceiptDetailViewModelInputs
                             , ReceiptDetailViewModelOutputs
, ReceiptDetailViewNavigationHandler {
  // inputs
  let backButtonPressed: PublishSubject<()> = .init()
  
  // outputs
  let receipt: Single<Receipt>
  var receiptImage: Single<UIImage?>
  
  // navigation
  let backNavigation: Observable<()>
  
  init(receipt receiptObj: Receipt) {
    receipt = Single.just(receiptObj)
    
    receiptImage = receipt
      .flatMap(Current.apiService.image)
      .map { res in res.value.flatMap { $0 } }
    
    backNavigation = backButtonPressed.asObservable()
  }
  
  var inputs: ReceiptDetailViewModelInputs { return self }
  var outputs: ReceiptDetailViewModelOutputs { return self }
  var navigation: ReceiptDetailViewNavigationHandler { return self }
}
