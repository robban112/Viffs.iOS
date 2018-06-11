//
//  RegisterUserViewModel.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-11.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation

protocol RegisterUserViewModelInputs {
  
}

protocol RegisterUserViewModelOutputs {
  
}

protocol RegisterUserViewModelType {
  var inputs: RegisterUserViewModelInputs { get }
  var outputs: RegisterUserViewModelOutputs { get }
}

struct RegisterUserViewModel: RegisterUserViewModelType
                            , RegisterUserViewModelInputs
, RegisterUserViewModelOutputs {
  
  
  var inputs: RegisterUserViewModelInputs { return self }
  var outputs: RegisterUserViewModelOutputs { return self }
}
