//
//  Mocks.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-09.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import RxSwift
import Result

// Environment mock
extension Environment {
  static var mock: Environment {
    return Environment(apiService: .mock, currentUser: nil)
  }
}

// APISerive mock
extension APIService {
  static var mock: APIService {
    return APIService(image: { r in Single.just(.success(nil)) })
  }
}
