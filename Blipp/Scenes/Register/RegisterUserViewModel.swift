//
//  RegisterUserViewModel.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-11.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseDatabase
import FirebaseAuth
import Overture

protocol RegisterUserViewModelInputs {
  var emailString: BehaviorSubject<String> { get }
  var passwordString: BehaviorSubject<String> { get }
  var createAccount: PublishSubject<Void> { get }
}

protocol RegisterUserViewModelOutputs {
  var correctEmail: Driver<Bool> { get }
  var correctPassword: Driver<Bool> { get }
}

protocol RegisterUserViewModelType: NavigationViewModelType {
  var inputs: RegisterUserViewModelInputs { get }
  var outputs: RegisterUserViewModelOutputs { get }
}

struct RegisterUserViewModel: RegisterUserViewModelType
                            , RegisterUserViewModelInputs
, RegisterUserViewModelOutputs {
  
  // database
  let database: DatabaseReference = Database.database().reference()
  
  // inputs
  let emailString = BehaviorSubject<String>(value: "")
  let passwordString = BehaviorSubject<String>(value: "")
  let createAccount = PublishSubject<Void>()
  
  // outputs
  let correctEmail: Driver<Bool>
  var correctPassword: Driver<Bool>
  
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
    
    navigate = createAccount.withLatestFrom(credentials)
      .flatMapLatest(
        pipe(
          Auth.auth().rx.createUser(withEmail:password:),
          { $0.map { _ in }.catchErrorJustReturn(()) }
        )
      )
      .flatMapLatest { coordinator.pop(animated: true) }
  }
  
  var inputs: RegisterUserViewModelInputs { return self }
  var outputs: RegisterUserViewModelOutputs { return self }
}
