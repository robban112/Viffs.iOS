//
//  LoginViewModelTests.swift
//  BlippTests
//
//  Created by Oskar Ek on 2018-06-06.
//  Copyright © 2018 Blipp. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import RxBlocking
@testable import BlippFramework

infix operator <-
func <- (_ disposeBag: DisposeBag, _ disposable: Disposable) {
  disposable.disposed(by: disposeBag)
}

class LoginViewModelTests: TestCase {
  
  let emails = [ "0"  : ""
               , "e1" : "something"
               , "e2" : "blipp@blipp.se" ]
  
  let passwords = [ "0"  : ""
                  , "p1" : "123" ]
  
  let booleans = [ "f" : false
                 , "t" : true ]
  
  func testLoginButtonEnabled() {
    // contract: loginButtonEnabled should only emit `true` when BOTH email and password strings are non-empty,
    // and should not emit repeated values
    let bag = DisposeBag()
    let scheduler = TestScheduler(initialClock: 0)
    let loginVM = LoginViewModel()
    
    let emailObservable = scheduler.createObservable(fromTimeline: "--0----e1---e2", values: emails)
    let pwdObservable   = scheduler.createObservable(fromTimeline: "----p1----0---", values: passwords)
    let expectedEvents  = scheduler.events(          fromTimeline: "f------t--f---", values: booleans)
    
    bag <- emailObservable.bind(to: loginVM.inputs.emailString)
    bag <- pwdObservable.bind(to: loginVM.inputs.passwordString)
    
    let buttonEnabled = scheduler.record(source: loginVM.outputs.loginButtonEnabled)
    
    scheduler.start()
    
    XCTAssertEqual(buttonEnabled.events, expectedEvents)
  }
}
