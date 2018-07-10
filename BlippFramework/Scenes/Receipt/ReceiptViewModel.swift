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

public protocol ReceiptViewModelInputs {
  var receiptSelected: PublishSubject<Receipt> { get }
}

public protocol ReceiptViewModelOutputs {
  var receiptsContents: Driver<[SectionModel<Int, Receipt>]> { get }
}

public protocol ReceiptViewModelType: NavigationViewModelType {
  var inputs: ReceiptViewModelInputs { get }
  var outputs: ReceiptViewModelOutputs { get }
  var navigate: Observable<Void> { get }
}

public struct ReceiptViewModel: ReceiptViewModelType, ReceiptViewModelInputs, ReceiptViewModelOutputs {
  public let receiptsContents: Driver<[SectionModel<Int, Receipt>]>
  public let receiptSelected = PublishSubject<Receipt>()
  
  let receiptDetailNavigation: Observable<Receipt>
  public let navigate: Observable<Void>
  
  public init(coordinator: SceneCoordinator = SceneCoordinator.shared) {
    receiptsContents = Current.apiService.receipts()
      .asDriver(onErrorJustReturn: [])
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
  
  public var inputs: ReceiptViewModelInputs { return self }
  public var outputs: ReceiptViewModelOutputs { return self }
}


