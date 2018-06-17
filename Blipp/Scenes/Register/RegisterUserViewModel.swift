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
import Overture

protocol RegisterUserViewModelInputs {
  var emailString: BehaviorSubject<String> { get }
  var passwordString: BehaviorSubject<String> { get }
  var createAccount: PublishSubject<Void> { get }
}

protocol RegisterUserViewModelOutputs {
  var emailState: Driver<InputState> { get }
  var passwordState: Driver<InputState> { get }
  var registerButtonEnabled: Driver<Bool> { get }
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
  
  // inputs
  let emailString = BehaviorSubject<String>(value: "")
  let passwordString = BehaviorSubject<String>(value: "")
  let createAccount = PublishSubject<Void>()
  
  // outputs
  let emailState: Driver<InputState>
  let passwordState: Driver<InputState>
  let registerButtonEnabled: Driver<Bool>
  
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
      .flatMapLatest { pwd in
        pwd.isEmpty
          ? Observable.just(.unInitiated)
          : Current.apiService.isValidPassword(pwd)
              .map { $0 ? .wellFormed : .illFormed }
              .asObservable()
      }
      .asDriver(onErrorJustReturn: .unInitiated)
    
    let wellformedEmail = emailState.map { $0 == .wellFormed }
    let wellformedPassword = passwordState.map { $0 == .wellFormed }
    registerButtonEnabled = Driver
      .combineLatest(wellformedEmail, wellformedPassword) { $0 && $1 }
      .distinctUntilChanged()
    
    let credentials: Observable<(String,String)> = Observable
      .combineLatest(emailString, passwordString)
    
    navigate = createAccount.withLatestFrom(credentials)
      .flatMapLatest(Current.auth.createUser)
      .flatMapLatest { _ in coordinator.pop(animated: true) }
  }
  
  var inputs: RegisterUserViewModelInputs { return self }
  var outputs: RegisterUserViewModelOutputs { return self }
}
