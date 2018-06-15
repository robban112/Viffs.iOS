//
//  Mocks.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-09.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth
import Result

// Environment mock
extension Environment {
  static var mock: Environment {
    return Environment(
      apiService: .mock,
      auth: .mock,
      currentUser: nil
    )
  }
}

// APISerive mock
extension APIService {
  static var mock: APIService {
    return APIService(image: { _ in .just(.success(.init())) })
  }
}

// Auth mock
extension Auth {
  static var mock: Auth {
    return Auth(
      signIn: { _, _ in .just(.success(.mock)) },
      createUser: { _, _ in .just(.success(.mock)) }
    )
  }
}

// User mock
extension User {
  static var mock: User {
    return .init(id: "", email: nil)
  }
}
