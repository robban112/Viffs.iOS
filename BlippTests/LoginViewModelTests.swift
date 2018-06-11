//
//  LoginViewModelTests.swift
//  BlippTests
//
//  Created by Oskar Ek on 2018-06-06.
//  Copyright © 2018 Blipp. All rights reserved.
//

import XCTest
import RxTest
import RxBlocking
@testable import Blipp

class LoginViewModelTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    Current = .mock
  }
  
  func testCorrectEmail() {
    let loginViewModel = LoginViewModel()
    let blockedCorrEmail = loginViewModel.correctEmail.toBlocking()
    XCTAssertEqual(try blockedCorrEmail.first(), .some(false))
    loginViewModel.inputs.emailString.onNext("test_email@blipp.se")
    XCTAssertEqual(try blockedCorrEmail.first(), .some(true))
    loginViewModel.inputs.emailString.onNext("test_email@blipp.")
    XCTAssertEqual(try blockedCorrEmail.first(), .some(false))
  }
  
  func testCorrectPassword() {
    let loginViewModel = LoginViewModel()
    let blockedCorrPwd = loginViewModel.correctPassword.toBlocking()
    XCTAssertEqual(try blockedCorrPwd.first(), .some(false))
    loginViewModel.inputs.emailString.onNext("pwd123")
    XCTAssertEqual(try blockedCorrPwd.first(), .some(true))
    loginViewModel.inputs.emailString.onNext("pwd")
    XCTAssertEqual(try blockedCorrPwd.first(), .some(false))
  }
}
