//
//  Auth.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-15.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import RxSwift
import Result
import Overture

enum FirebaseError: Error {
  case logInError(String)
  case userCreateError(String)
}

fileprivate let apiURL = URL(string: "https://blipp-6c73b.firebaseio.com/users.json")!

struct Auth {
  /// Sign in with a given username and password
  var signIn: (String, String) -> Single<Result<User, FirebaseError>> = signIn(withEmail:password:)
  /// create a new user
  var createUser: (String, String) -> Single<Result<(), FirebaseError>> = createUser(withEmail:password:)
}

// MARK: live implementations
func signIn(withEmail username: String, password: String) -> Single<Result<User, FirebaseError>> {
  return Single.create(subscribe: { single -> Disposable in
    let task = URLSession.shared.dataTask(with: apiURL) { (data, response, error) in
      guard
        let responseData = data,
        let users = try? JSONDecoder().decode([String: User].self, from: responseData),
        let matchingUser = users.map({ $0.1 }).first(where: { $0.username == username && $0.password == password }) else {
          single(.success(.failure(.logInError("Could not log in"))))
          return
      }
      single(.success(.success(matchingUser)))
    }
    task.resume()
    return Disposables.create {
      task.cancel()
    }
  })
}

// TODO: fix createUser, adds username and password as two separate entries currently, need to nest into an array
func createUser(withEmail username: String, password: String) -> Single<Result<(), FirebaseError>> {
  return Single.create(subscribe: { single in
    let credentials = ["username": username, "password": password]
    let jsonCredentials = try! JSONSerialization.data(withJSONObject: credentials, options: [])
    let request = with(URLRequest(url: apiURL), concat(
      set(\URLRequest.httpMethod, "POST"),
      set(\URLRequest.httpBody, jsonCredentials)
    ))
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        single(.success(.failure(.logInError(String(describing: error)))))
      } else {
        single(.success(.success(())))
      }
    }
    task.resume()
    return Disposables.create {
      task.cancel()
    }
  })
}
