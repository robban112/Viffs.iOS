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
  var emailState: Driver<InputState> { get }
  var passwordState: Driver<InputState> { get }
}

protocol RegisterUserViewModelType: NavigationViewModelType {
  var inputs: RegisterUserViewModelInputs { get }
  var outputs: RegisterUserViewModelOutputs { get }
}

enum InputState {
  case unInitiated
  case wellFormed
  case illFormed
}

func inputState(isWellFormed: @escaping (String) -> Bool)
  -> (String)
  -> InputState {
  return { string in
    switch (string.isEmpty, isWellFormed(string)) {
    case (true, _): return .unInitiated
    case (_, false): return .illFormed
    case (_, true): return .wellFormed
    }
  }
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
  let emailState: Driver<InputState>
  let passwordState: Driver<InputState>
  
  // navigation
  let navigate: Observable<Void>
  
  init() {
    self.init(coordinator: SceneCoordinator.shared)
  }
  
  init(coordinator: SceneCoordinator) {
    emailState = emailString
      .map(inputState(isWellFormed: get(\.isValidEmail)))
      .asDriver(onErrorJustReturn: .unInitiated)
    
    passwordState = passwordString
      .map(inputState(isWellFormed: get(\.isValidPassword)))
      .asDriver(onErrorJustReturn: .unInitiated)
    
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
