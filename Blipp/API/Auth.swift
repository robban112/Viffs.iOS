//
//  Auth.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-15.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth
import FirebaseDatabase
import Result
import Overture

enum FirebaseError: Error {
  case logInError(String)
  case userCreateError(String)
}

extension User {
  init(fbUser: FirebaseAuth.User) {
    self.id = fbUser.uid
    self.email = fbUser.email
  }
}

struct Auth {
  /// Sign in with a given username and password
  var signIn: (String, String) -> Single<Result<User, FirebaseError>> = signIn(withEmail:password:)
  /// create a new user
  var createUser: (String, String) -> Single<Result<User, FirebaseError>> = createUser(withEmail:password:)
}

// MARK: Live implementations
func signIn(withEmail email: String, password: String) -> Single<Result<User, FirebaseError>> {
  return Single.create(subscribe: { single -> Disposable in
    FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { (userData, error) in
      if let user = userData?.user {
        single(.success(.success(.init(fbUser: user))))
      } else if let err = error {
        single(.success(.failure(.logInError(String(describing: err)))))
      }
    }
    return Disposables.create()
  })
}

func createUser(withEmail email: String, password: String) -> Single<Result<User, FirebaseError>> {
  return Single.create(subscribe: { single in
    FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { (userData, error) in
      if let user = userData?.user {
        Database.database().reference().child("users").child(user.uid).setValue(["username": user.email])
        single(.success(.success(.init(fbUser: user))))
      } else if let err = error {
        single(.success(.failure(.userCreateError(String(describing: err)))))
      }
    }
    return Disposables.create()
  })
}
