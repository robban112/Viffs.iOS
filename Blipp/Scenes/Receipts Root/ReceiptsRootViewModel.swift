//
//  LoginViewModel.swift
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
}

protocol ReceiptsRootViewModelType: NavigationViewModelType {
    var inputs: ReceiptsRootViewModelInputs { get }
}

struct ReceiptsRootViewModel: ReceiptsRootViewModelType
    , ReceiptsRootViewModelInputs {
    
    // inputs
    let receipts = PublishSubject<Void>()
    let sorted = PublishSubject<Void>()
    
    // navigation
    let navigate: Observable<Void>
    
    init() {
        self.init(coordinator: SceneCoordinator.shared)
    }
    
    init(coordinator: SceneCoordinator) {
        navigate = receipts.flatMapLatest {
            coordinator.transition(to: Scene.receipt(ReceiptViewModel()))
        }
    }
    
    var inputs: ReceiptsRootViewModelInputs { return self }
}
