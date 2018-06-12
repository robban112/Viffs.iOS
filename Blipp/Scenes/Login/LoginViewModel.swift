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
import FirebaseAuth
import Overture

protocol LoginViewModelInputs {
  var emailString: BehaviorSubject<String> { get }
  var passwordString: BehaviorSubject<String> { get }
  var registerUser: PublishSubject<Void> { get }
  var login: PublishSubject<()> { get }
}

protocol LoginViewModelOutputs {
  var correctEmail: Driver<Bool> { get }
  var correctPassword: Driver<Bool> { get }
  var loginResult: Observable<Result<User, FirebaseError>> { get }
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
  let registerUser = PublishSubject<Void>()
  let login = PublishSubject<()>()
  
  // outputs
  let correctEmail: Driver<Bool>
  var correctPassword: Driver<Bool>
  let loginResult: Observable<Result<User, FirebaseError>>
  
  // navigation
  let navigate: Observable<Void>
  
  init() {
    self.init(coordinator: SceneCoordinator.shared)
  }
  
  init(coordinator: SceneCoordinator) {
    correctEmail = emailString
      .asDriver(onErrorJustReturn: "")
      .map(get(\.isValidEmail))
      .distinctUntilChanged()
    
    correctPassword = passwordString
      .asDriver(onErrorJustReturn: "")
      .map(get(\.isValidPassword))
      .distinctUntilChanged()
    
    let credentials: Observable<(String,String)> = Observable
      .combineLatest(emailString, passwordString)
    
    loginResult = login.withLatestFrom(credentials)
      .flatMapLatest(
        pipe(
          Auth.auth().rx.signIn(withEmail:password:),
          { $0.catchErrorJustReturn(.failure(.logInError("Unexpected login error"))) }
        )
      )

    navigate = registerUser.flatMapLatest {
      coordinator.transition(to: Scene.registerUser(RegisterUserViewModel()))
    }
  }
  
  var inputs: LoginViewModelInputs { return self }
  var outputs: LoginViewModelOutputs { return self }
}
