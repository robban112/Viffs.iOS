//
//  WelcomeViewModel.swift
//  Blipp
//
//  Created by Kristofer Pitkäjärvi on 2018-06-29.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Overture

public protocol WelcomeViewModelInputs {
    var registerUser: PublishSubject<Void> { get }
    var login: PublishSubject<Void> { get }
}

public protocol WelcomeViewModelType: NavigationViewModelType {
    var inputs: WelcomeViewModelInputs { get }
}

public struct WelcomeViewModel: WelcomeViewModelType, WelcomeViewModelInputs{
    // inputs
  public let registerUser = PublishSubject<Void>()
  public let login = PublishSubject<()>()
    
    
    // navigation
  public let navigate: Observable<Void>
    
    public init() {
        self.init(coordinator: SceneCoordinator.shared)
    }
    
    public init(coordinator: SceneCoordinator) {
        
        let navigate1 = registerUser.flatMapLatest {
            coordinator.transition(to: Scene.registerUser(RegisterUserViewModel()))
        }
        let navigate2 = login.flatMapLatest {
            coordinator.transition(to: Scene.login(LoginViewModel()))
        }
        navigate = Observable.merge(navigate1, navigate2)
    }
  public var inputs: WelcomeViewModelInputs { return self }
}
