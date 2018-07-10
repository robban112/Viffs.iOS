//
//  RegisterUserViewModelTests.swift
//  BlippTests
//
//  Created by Oskar Ek on 2018-06-17.
//  Copyright © 2018 Blipp. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import RxBlocking
import Overture
@testable import BlippFramework

class RegisterUserViewModelTests: TestCase {
  
  let emails = [ "0"  : ""
               , "e1" : "something"
               , "e2" : "blipp@blipp.se" ]
  
  let passwords = [ "0"  : ""
                  , "p1" : "12"
                  , "p2" : "123" ]
  
  let booleans = [ "f" : false
                 , "t" : true ]
  
  func testLoginButtonEnabled() {
    // contract: registerButtonEnabled should only emit `true` when emailString is a valid email
    // and passwordString is a valid password, and should not emit repeated values.
    
    // setup current environment
    update(&Current,
      set(\.apiService.isValidPassword, { .just($0.count > 2) })
    )
    
    let bag = DisposeBag()
    let scheduler = TestScheduler(initialClock: 0)
    let registerUserVM = RegisterUserViewModel()
    
    let emailObservable = scheduler.createObservable(fromTimeline: "--0----e2----e1", values: emails)
    let pwdObservable   = scheduler.createObservable(fromTimeline: "----p1----p2---", values: passwords)
    let expectedEvents  =           scheduler.events(fromTimeline: "f---------t--f-", values: booleans)
    
    emailObservable.bind(to: registerUserVM.inputs.emailString).disposed(by: bag)
    pwdObservable.bind(to: registerUserVM.inputs.passwordString).disposed(by: bag)
    
    let buttonEnabled = scheduler.record(source: registerUserVM.outputs.registerButtonEnabled)
    
    scheduler.start()
    
    XCTAssertEqual(buttonEnabled.events, expectedEvents)
  }
    
}
