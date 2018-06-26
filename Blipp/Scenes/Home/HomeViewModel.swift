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
import Result
import Overture

protocol HomeViewModelInputs {
    var receipts: PublishSubject<Void> { get }
    var stores: PublishSubject<Void> { get }
}

protocol HomeViewModelType: NavigationViewModelType {
    var inputs: HomeViewModelInputs { get }
}

struct HomeViewModel: HomeViewModelType
, HomeViewModelInputs {
    
    // inputs
    let receipts = PublishSubject<Void>()
    let stores = PublishSubject<Void>()
    
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
    
    var inputs: HomeViewModelInputs { return self }
}
