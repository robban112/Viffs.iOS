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

protocol WelcomeViewModelInputs {
    var registerUser: PublishSubject<Void> { get }
    var login: PublishSubject<Void> { get }
}

protocol WelcomeViewModelType: NavigationViewModelType {
    var inputs: WelcomeViewModelInputs { get }
}

struct WelcomeViewModel: WelcomeViewModelType, WelcomeViewModelInputs{
    // inputs
    let registerUser = PublishSubject<Void>()
    let login = PublishSubject<()>()
    
    
    // navigation
    let navigate: Observable<Void>
    
    init() {
        self.init(coordinator: SceneCoordinator.shared)
    }
    
    init(coordinator: SceneCoordinator) {
        
        let navigate1 = registerUser.flatMapLatest {
            coordinator.transition(to: Scene.registerUser(RegisterUserViewModel()))
        }
        let navigate2 = login.flatMapLatest {
            coordinator.transition(to: Scene.login(LoginViewModel()))
        }
        navigate = Observable.merge(navigate1, navigate2)
    }
    var inputs: WelcomeViewModelInputs { return self }
}
