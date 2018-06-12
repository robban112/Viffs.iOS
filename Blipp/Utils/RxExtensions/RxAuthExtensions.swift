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
import FirebaseDatabase
import Result

enum FirebaseError: Error {
  case logInError(String)
  case userCreateError(String)
}

// OBS: temporary solution.
// All of this will probably not be defined like this, but instead be
// methods in an API struct or something so it can be mocked.
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
  
  // create a new user
  func createUser(withEmail email: String, password: String) -> Single<Result<User, FirebaseError>> {
    return Single.create(subscribe: { single in
      Auth.auth().createUser(withEmail: email, password: password) { (userData, error) in
        if let error = error {
          print(error.localizedDescription)
          single(.success(.failure(.userCreateError(String.init(describing: error)))))
        } else {
          if let user = userData?.user {
            print("Successfully created user!")
            Database.database().reference().child("users").child(user.uid).setValue(["username": user.email])
            single(.success(.success(user)))
          }
        }
      }
      return Disposables.create()
    })
  }
}
