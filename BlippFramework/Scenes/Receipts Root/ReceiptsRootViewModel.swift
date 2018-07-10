//
//  ReceiptsRootViewModel.swift
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

public protocol ReceiptsRootViewModelInputs {
    var receipts: PublishSubject<Void> { get }
    var sorted: PublishSubject<Void> { get }
    var scan: PublishSubject<Void> { get }
}

public protocol ReceiptsRootViewModelType: NavigationViewModelType {
    var inputs: ReceiptsRootViewModelInputs { get }
}

public struct ReceiptsRootViewModel: ReceiptsRootViewModelType
, ReceiptsRootViewModelInputs {
    
    // inputs
  public let receipts = PublishSubject<Void>()
  public let sorted = PublishSubject<Void>()
  public let scan = PublishSubject<Void>()
    
    // navigation
  public let navigate: Observable<Void>
    
    public init() {
        self.init(coordinator: SceneCoordinator.shared)
    }
    
    public init(coordinator: SceneCoordinator) {
        
        let navigate1 = receipts.flatMapLatest {
            coordinator.transition(to: Scene.receipts(ReceiptViewModel()))
        }
        //currently transitions to same as above
        let navigate2 = sorted.flatMapLatest {
            coordinator.transition(to: Scene.receiptsSorted(ReceiptViewModel()))
        }
        //currently transitions to same as above
        let navigate3 = scan.flatMapLatest {
            coordinator.transition(to: Scene.scanReceipt)
        }
        navigate = Observable.merge(navigate1, navigate2, navigate3)
    }
    
  public var inputs: ReceiptsRootViewModelInputs { return self }
}
