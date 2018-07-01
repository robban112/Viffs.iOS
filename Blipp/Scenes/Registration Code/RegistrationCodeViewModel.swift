//
//  RegistrationCodeViewModel.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-07-01.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Overture

protocol RegistrationCodeViewModelInputs {
  var continueButton: PublishSubject<Void> { get }
}

protocol RegistrationCodeViewModelOutputs {
}

protocol RegistrationCodeViewModelType: NavigationViewModelType {
  var inputs: RegistrationCodeViewModelInputs { get }
  var outputs: RegistrationCodeViewModelOutputs { get }
}

struct RegistrationCodeViewModel: RegistrationCodeViewModelType
  , RegistrationCodeViewModelInputs
, RegistrationCodeViewModelOutputs {
  
  // inputs
  let continueButton = PublishSubject<Void>()
  
  // navigation
  let navigate: Observable<Void>
  
  init() {
    self.init(coordinator: SceneCoordinator.shared)
  }
  
  init(coordinator: SceneCoordinator) {
    let navigateContinue = continueButton.flatMapLatest {
      coordinator.transition(to: Scene.blipp)
    }
    
    navigate = navigateContinue
  }
  
  var inputs: RegistrationCodeViewModelInputs { return self }
  var outputs: RegistrationCodeViewModelOutputs { return self }
}
