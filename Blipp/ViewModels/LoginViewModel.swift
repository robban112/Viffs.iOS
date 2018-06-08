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
import Firebase
import Overture

protocol LoginViewModelInputs {
  var emailString: BehaviorSubject<String> { get }
  var passwordString: BehaviorSubject<String> { get }
  var login: PublishSubject<()> { get }
}

protocol LoginViewModelOutputs {
  var correctEmail: Driver<Bool> { get }
  var correctPassword: Driver<Bool> { get }
  var loginResult: Observable<Result<User, FirebaseError>> { get }
}

protocol LoginViewModelType {
  var inputs: LoginViewModelInputs { get }
  var outputs: LoginViewModelOutputs { get }
}

struct LoginViewModel: LoginViewModelType, LoginViewModelInputs, LoginViewModelOutputs {
  // inputs
  let emailString = BehaviorSubject<String>(value: "")
  let passwordString = BehaviorSubject<String>(value: "")
  let login = PublishSubject<()>()
  
  // outputs
  let correctEmail: Driver<Bool>
  var correctPassword: Driver<Bool>
  let loginResult: Observable<Result<User, FirebaseError>>
  
  // disposeBag
  let disposeBag = DisposeBag()
  
  init() {
    correctEmail = emailString
      .asDriver(onErrorJustReturn: "")
      .map(get(\.isValidEmail))
      .distinctUntilChanged()
    
    correctPassword = passwordString
      .asDriver(onErrorJustReturn: "")
      .map(get(\.isValidPassword))
      .distinctUntilChanged()
    
    let credentials = Observable<(String,String)>
      .combineLatest(emailString, passwordString) { ($0,$1) }
    
    loginResult = login.withLatestFrom(credentials)
      .flatMapLatest { t -> Observable<Result<User, FirebaseError>> in
        Auth.auth().rx.signIn(withEmail: t.0, password: t.1)
          .asObservable()
          .catchErrorJustReturn(.failure(.logInError("Unexpected login error")))
      }
    
    loginResult
      .subscribe(onNext: { userRes in
        switch userRes {
        case let .success(user): print("User \(String(describing: user)) logged in!")
        case let .failure(err): print("Login error: \(String.init(describing: err))")
        }
      })
      .disposed(by: disposeBag)
  }
  
  var inputs: LoginViewModelInputs { return self }
  var outputs: LoginViewModelOutputs { return self }
}
