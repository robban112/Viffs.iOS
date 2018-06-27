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

protocol ReceiptsRootViewModelInputs {
    var receipts: PublishSubject<Void> { get }
    var sorted: PublishSubject<Void> { get }
    var scan: PublishSubject<Void> { get }
}

protocol ReceiptsRootViewModelType: NavigationViewModelType {
    var inputs: ReceiptsRootViewModelInputs { get }
}

struct ReceiptsRootViewModel: ReceiptsRootViewModelType
, ReceiptsRootViewModelInputs {
    
    // inputs
    let receipts = PublishSubject<Void>()
    let sorted = PublishSubject<Void>()
    let scan = PublishSubject<Void>()
    
    // navigation
    let navigate: Observable<Void>
    
    init() {
        self.init(coordinator: SceneCoordinator.shared)
    }
    
    init(coordinator: SceneCoordinator) {
        
        let navigate1 = receipts.flatMapLatest {
            coordinator.transition(to: Scene.receipt(ReceiptViewModel()))
        }
        //currently transitions to same as above
        let navigate2 = sorted.flatMapLatest {
            coordinator.transition(to: Scene.receipt(ReceiptViewModel()))
        }
        //currently transitions to same as above
        let navigate3 = scan.flatMapLatest {
            coordinator.transition(to: Scene.receipt(ReceiptViewModel()))
        }
        navigate = Observable.merge(navigate1, navigate2, navigate3)
    }
    
    var inputs: ReceiptsRootViewModelInputs { return self }
}
