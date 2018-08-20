//
//  HomeViewModel.swift
//  Blipp
//
//  Created by Kristofer P on 2018-06-26.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Result
import Overture

protocol HomeViewModelInputs {
  var stores: PublishSubject<Void> { get }
  var addCard: PublishSubject<Void> { get }
  var showAllReceiptsButtonPressed: PublishSubject<Void> { get }
  var receiptSelected: PublishSubject<Receipt> { get }
}

protocol HomeViewModelOutputs {
  var receiptsContents: Driver<[SectionModel<Int, Receipt>]> { get }
}

protocol HomeViewModelType: NavigationViewModelType {
  var inputs: HomeViewModelInputs { get }
  var outputs: HomeViewModelOutputs { get }
}

struct HomeViewModel: HomeViewModelType
, HomeViewModelInputs, HomeViewModelOutputs {
  
  // inputs
  let stores = PublishSubject<Void>()
  let addCard = PublishSubject<Void>()
  let showAllReceiptsButtonPressed = PublishSubject<Void>()
  let receiptSelected = PublishSubject<Receipt>()
  
  // outputs
  let receiptsContents: Driver<[SectionModel<Int, Receipt>]>
  
  // navigation
  let navigate: Observable<Void>
  
  init() {
    self.init(coordinator: SceneCoordinator.shared)
  }
  
  init(coordinator: SceneCoordinator) {
    receiptsContents = Current.apiService.receipts()
      .asDriver(onErrorJustReturn: [])
      .map { receipts in
        [SectionModel(model: 0, items: receipts)]
    }
    
    let navigateStores = stores.flatMapLatest {
      coordinator.transition(to: Scene.stores)
    }
    let navigateAllReceipts = showAllReceiptsButtonPressed.flatMapLatest {
      coordinator.transition(to: Scene.receipts(.init()))
    }
    let navigateReceiptDetail = receiptSelected.flatMapLatest { receipt -> Observable<Void> in
      coordinator.transition(to: Scene.receipts(.init()))
      return coordinator.transition(to: Scene.receiptDetail(.init(receipt: receipt)))
    }
    navigate = Observable.merge(navigateStores, navigateAllReceipts, navigateReceiptDetail)
  }
  
  var inputs: HomeViewModelInputs { return self }
  var outputs: HomeViewModelOutputs { return self }
}
