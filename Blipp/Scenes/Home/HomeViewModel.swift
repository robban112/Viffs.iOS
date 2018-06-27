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
    var addCard: PublishSubject<Void> { get } 
}

protocol HomeViewModelType: NavigationViewModelType {
    var inputs: HomeViewModelInputs { get }
}

struct HomeViewModel: HomeViewModelType
, HomeViewModelInputs {
    
    // inputs
    let receipts = PublishSubject<Void>()
    let stores = PublishSubject<Void>()
    let addCard = PublishSubject<Void>()
    
    // navigation
    let navigate: Observable<Void>
    
    init() {
        self.init(coordinator: SceneCoordinator.shared)
    }
    
    init(coordinator: SceneCoordinator) {
        let navigate1 = receipts.flatMapLatest {
            coordinator.transition(to: Scene.receipt(ReceiptViewModel()))
        }
        let navigate2 = stores.flatMapLatest {
            coordinator.transition(to: Scene.stores)
        }
        navigate = Observable.merge(navigate1, navigate2)
    }
    
    var inputs: HomeViewModelInputs { return self }
}
