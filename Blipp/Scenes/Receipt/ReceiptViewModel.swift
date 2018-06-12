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
import RxDataSources
import Overture

protocol ReceiptViewModelInputs {
  var receiptSelected: PublishSubject<Receipt> { get }
}

protocol ReceiptViewModelOutputs {
  var receiptsContents: Driver<[SectionModel<Int, Receipt>]> { get }
}

protocol ReceiptViewModelType: NavigationViewModelType {
  var inputs: ReceiptViewModelInputs { get }
  var outputs: ReceiptViewModelOutputs { get }
  var navigate: Observable<Void> { get }
}

struct ReceiptViewModel: ReceiptViewModelType, ReceiptViewModelInputs, ReceiptViewModelOutputs {
  let receiptsContents: Driver<[SectionModel<Int, Receipt>]>
  let receiptSelected = PublishSubject<Receipt>()
  
  let receiptDetailNavigation: Observable<Receipt>
  let navigate: Observable<Void>
  
  init(coordinator: SceneCoordinator = SceneCoordinator.shared) {
    receiptsContents = Driver
      .just([ Receipt(name: "Pressbyrån", total: "30", url: "")
            , Receipt(name: "ICA", total: "200", url: "http://static.feber.se/article_images/19/53/44/195344_980.jpg") ])
      .map { receipts in
        [SectionModel(model: 0, items: receipts)]
      }
    
    navigate = receiptSelected
      .flatMapLatest(
        pipe(
          ReceiptDetailViewModel.init(receipt:),
          Scene.receiptDetail,
          coordinator.transition(to:)
        )
      )
    
    receiptDetailNavigation = receiptSelected.asObservable()
  }
  
  var inputs: ReceiptViewModelInputs { return self }
  var outputs: ReceiptViewModelOutputs { return self }
}


