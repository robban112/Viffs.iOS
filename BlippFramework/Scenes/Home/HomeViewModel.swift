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

public protocol HomeViewModelInputs {
    var receipts: PublishSubject<Void> { get }
    var stores: PublishSubject<Void> { get }
    var addCard: PublishSubject<Void> { get } 
}

public protocol HomeViewModelType: NavigationViewModelType {
    var inputs: HomeViewModelInputs { get }
}

public struct HomeViewModel: HomeViewModelType
, HomeViewModelInputs {
    
    // inputs
  public let receipts = PublishSubject<Void>()
  public let stores = PublishSubject<Void>()
  public let addCard = PublishSubject<Void>()
    
    // navigation
  public let navigate: Observable<Void>
    
    public init() {
        self.init(coordinator: SceneCoordinator.shared)
    }
    
    public init(coordinator: SceneCoordinator) {
        let navigate1 = receipts.flatMapLatest {
            coordinator.transition(to: Scene.receipts(ReceiptViewModel()))
        }
        let navigate2 = stores.flatMapLatest {
            coordinator.transition(to: Scene.stores)
        }
        navigate = Observable.merge(navigate1, navigate2)
    }
    
  public var inputs: HomeViewModelInputs { return self }
}
