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
    // Put setup code here. This method is called before the invocation of each test method in the class.
    Current = .mock
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testCorrectEmail() {
    let loginViewModel = LoginViewModel()
    let blockedCorrEmail = loginViewModel.correctEmail.toBlocking()
    XCTAssertEqual(try blockedCorrEmail.first(), .some(false))
    loginViewModel.inputs.emailString.onNext("test_email@blipp.se")
    XCTAssertEqual(try blockedCorrEmail.first(), .some(true))
  }
}
