//
//  RxAuthExtensions.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-03.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth
import Result

enum FirebaseError: Error {
  case logInError(String)
}

extension Reactive where Base: Auth {
  // Sign in with a given username and password
  func signIn(withEmail email: String, password: String) -> Single<Result<User, FirebaseError>> {
    return Single.create(subscribe: { single -> Disposable in
      Auth.auth().signIn(withEmail: email, password: password, completion: { (userData, error) in
        if let user = userData?.user {
          single(.success(.success(user)))
        } else if let err = error {
          single(.success(.failure(.logInError(String(describing: err)))))
        }
      })
      return Disposables.create()
    })
  }
}
