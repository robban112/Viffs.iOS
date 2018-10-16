//
//  LoginViewModel.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-05-31.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Result
import Overture

protocol LoginViewModelInputs {
  var emailString: BehaviorSubject<String> { get }
  var passwordString: BehaviorSubject<String> { get }
  var login: PublishSubject<()> { get }
}

protocol LoginViewModelOutputs {
  var loginResult: Observable<Result<User, FirebaseError>> { get }
  var loginButtonEnabled: Driver<Bool> { get }
}

protocol LoginViewModelType: NavigationViewModelType {
  var inputs: LoginViewModelInputs { get }
  var outputs: LoginViewModelOutputs { get }
}

struct LoginViewModel: LoginViewModelType
                     , LoginViewModelInputs
                     , LoginViewModelOutputs {
  // inputs
  let emailString = BehaviorSubject<String>(value: "")
  let passwordString = BehaviorSubject<String>(value: "")
  let login = PublishSubject<()>()
  
  // outputs
  let loginResult: Observable<Result<User, FirebaseError>>
  let loginButtonEnabled: Driver<Bool>
  
  // navigation
  let navigate: Observable<Void>
  
  init() {
    self.init(coordinator: SceneCoordinator.shared)
  }
  
  init(coordinator: SceneCoordinator) {
    let credentials = Observable
      .combineLatest(emailString, passwordString)
    
    loginResult = login.withLatestFrom(credentials)
      .flatMapLatest(Current.auth.signIn)
      .debug()
    
    let emptyEmail = emailString.map(get(\.isEmpty))
    let emptyPwd = passwordString.map(get(\.isEmpty))
    loginButtonEnabled = Observable
      .combineLatest(emptyEmail, emptyPwd) { !$0 && !$1 }
      .distinctUntilChanged()
      .asDriver(onErrorJustReturn: false)
    
    let newUser = loginResult
      .map(get(\.value))
      .flatMap { $0.map(Observable.just) ?? .empty() }
    
    let setCurrentUser = newUser.do(onNext: {
        update(&Current, set(\.currentUser, $0))
    })

    navigate = setCurrentUser.flatMapLatest { _ in
      coordinator.transition(to: Scene.blipp)
    }
  }
  
  var inputs: LoginViewModelInputs { return self }
  var outputs: LoginViewModelOutputs { return self }
}