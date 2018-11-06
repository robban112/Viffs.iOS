//
//  MittViffsViewModel.swift
//  Blipp
//
//  Created by Kristofer P on 2018-06-26.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Result
import Overture
import RxDataSources

protocol MittViffsViewModelInputs {
  var receiptCollectionSelected: PublishSubject<ReceiptCollection> { get }
}

protocol MittViffsViewModelOutputs {
  var receiptCollectionsContents: Driver<[SectionModel<Int, ReceiptCollection>]> { get }
}

protocol MittViffsViewModelType: NavigationViewModelType {
  var inputs: MittViffsViewModelInputs { get }
  var outputs: MittViffsViewModelOutputs { get }
}

struct MittViffsViewModel: MittViffsViewModelType
, MittViffsViewModelInputs, MittViffsViewModelOutputs {
  
  // inputs
  let receiptCollectionSelected = PublishSubject<ReceiptCollection>()
  
  // outputs
  let receiptCollectionsContents: Driver<[SectionModel<Int, ReceiptCollection>]>
  
  // navigation
  let navigate: Observable<Void>
  
  init() {
    self.init(coordinator: SceneCoordinator.shared)
  }
  
  init(coordinator: SceneCoordinator) {
    receiptCollectionsContents = Driver.just([
      ReceiptCollection(name: "Alla kvitton", logo: UIImage(named: "Inbox-beige")!, scene: Scene.receipts()),
      ReceiptCollection(name: "Butiker", logo: UIImage(named: "Butiker - Beige")!, scene: Scene.stores),
      ReceiptCollection(name: "Kort", logo: UIImage(named: "Cards-beige-")!, scene: Scene.cards),
      ReceiptCollection(name: "Importerat", logo: UIImage(named: "imported-Beige-")!, scene: Scene.receipts())
      ])
      .map { receiptCollections in
        [SectionModel(model: 0, items: receiptCollections)]
      }
    
    
    
    navigate = receiptCollectionSelected.flatMapLatest { receiptColl in
      SceneCoordinator.shared.transition(to: receiptColl.scene)
    }
  }
  
  var inputs: MittViffsViewModelInputs { return self }
  var outputs: MittViffsViewModelOutputs { return self }
}
