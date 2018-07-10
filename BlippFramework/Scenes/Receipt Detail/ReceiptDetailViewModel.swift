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

public protocol ReceiptDetailViewModelInputs {
  var backButtonPressed: PublishSubject<()> { get }
}

public protocol ReceiptDetailViewModelOutputs {
  var receipt: Single<Receipt> { get }
  var receiptImage: Single<UIImage?> { get }
}

public protocol ReceiptDetailViewModelType: NavigationViewModelType {
  var inputs: ReceiptDetailViewModelInputs { get }
  var outputs: ReceiptDetailViewModelOutputs { get }
}

public struct ReceiptDetailViewModel: ReceiptDetailViewModelType
                             , ReceiptDetailViewModelInputs
                             , ReceiptDetailViewModelOutputs {
  // inputs
  public let backButtonPressed: PublishSubject<()> = .init()
  
  // outputs
  public let receipt: Single<Receipt>
  public var receiptImage: Single<UIImage?>
  
  // navigation
  public let navigate: Observable<Void>
  
  init(receipt: Receipt) { self.init(receipt: receipt, coordinator: SceneCoordinator.shared) }
  
  init(receipt receiptObj: Receipt, coordinator: SceneCoordinatorType) {
    receipt = Single.just(receiptObj)
    
    receiptImage = receipt
      .flatMap(Current.apiService.image)
      .map { res in res.value.flatMap { $0 } }
    
    let backNavigation = backButtonPressed.asObservable()
      .flatMapLatest { coordinator.pop(animated: true) }
    
    navigate = backNavigation
  }
  
  public var inputs: ReceiptDetailViewModelInputs { return self }
  public var outputs: ReceiptDetailViewModelOutputs { return self }
}
