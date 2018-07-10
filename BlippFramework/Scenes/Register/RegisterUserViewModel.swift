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

public protocol RegisterUserViewModelInputs {
  var emailString: BehaviorSubject<String> { get }
  var passwordString: BehaviorSubject<String> { get }
  var createAccount: PublishSubject<Void> { get }
}

public protocol RegisterUserViewModelOutputs {
  var emailState: Driver<InputState> { get }
  var passwordState: Driver<InputState> { get }
  var registerButtonEnabled: Driver<Bool> { get }
}

public protocol RegisterUserViewModelType: NavigationViewModelType {
  var inputs: RegisterUserViewModelInputs { get }
  var outputs: RegisterUserViewModelOutputs { get }
}

public enum InputState {
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

public struct RegisterUserViewModel: RegisterUserViewModelType
                            , RegisterUserViewModelInputs
                            , RegisterUserViewModelOutputs {
  
  // inputs
  public let emailString = BehaviorSubject<String>(value: "")
  public let passwordString = BehaviorSubject<String>(value: "")
  public let createAccount = PublishSubject<Void>()
  
  // outputs
  public let emailState: Driver<InputState>
  public let passwordState: Driver<InputState>
  public let registerButtonEnabled: Driver<Bool>
  
  // navigation
  public let navigate: Observable<Void>
  
  public init() {
    self.init(coordinator: SceneCoordinator.shared)
  }
  
  public init(coordinator: SceneCoordinator) {
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
    
    let createUserResult = createAccount.withLatestFrom(credentials)
      .flatMapLatest(Current.auth.createUser)
    
    let newUser = createUserResult
      .map(get(\.value))
      .flatMap { $0.map(Observable.just) ?? .empty() }
    
    let setCurrentUser = newUser
      .do(onNext: {
        update(&Current, set(\.currentUser, $0))
      })
    
    let navigate1 = setCurrentUser
      .flatMapLatest { _ in coordinator.transition(to: Scene.registerCard(RegisterCardViewModel())) }
    navigate = navigate1
  }
  
  public var inputs: RegisterUserViewModelInputs { return self }
  public var outputs: RegisterUserViewModelOutputs { return self }
}
