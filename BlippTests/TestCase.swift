//
//  TestCase.swift
//  BlippTests
//
//  Created by Oskar Ek on 2018-06-17.
//  Copyright © 2018 Blipp. All rights reserved.
//

import XCTest
@testable import Blipp

class TestCase: XCTestCase {
    override func setUp() {
        super.setUp()
        Current = .mock
    }
}
