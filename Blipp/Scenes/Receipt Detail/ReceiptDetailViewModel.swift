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

protocol ReceiptDetailViewModelType: NavigationViewModelType {
  var inputs: ReceiptDetailViewModelInputs { get }
  var outputs: ReceiptDetailViewModelOutputs { get }
}

struct ReceiptDetailViewModel: ReceiptDetailViewModelType
                             , ReceiptDetailViewModelInputs
                             , ReceiptDetailViewModelOutputs {
  // inputs
  let backButtonPressed: PublishSubject<()> = .init()
  
  // outputs
  let receipt: Single<Receipt>
  var receiptImage: Single<UIImage?>
  
  // navigation
  let navigate: Observable<Void>
  
  init(receipt: Receipt) { self.init(receipt: receipt, coordinator: SceneCoordinator.shared) }
  
  init(receipt receiptObj: Receipt, coordinator: SceneCoordinatorType) {
    receipt = Single.just(receiptObj)
    
    receiptImage = Single.create { single in
      _ = getImage(for: receiptObj)
        .map(SingleEvent.success)
        .done(single)
      
      return Disposables.create()
    }
    
    let backNavigation = backButtonPressed.asObservable()
      .flatMapLatest { coordinator.pop(animated: true) }
    
    navigate = backNavigation
  }
  
  var inputs: ReceiptDetailViewModelInputs { return self }
  var outputs: ReceiptDetailViewModelOutputs { return self }
}
