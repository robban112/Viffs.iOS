//
//  RegisterCardViewModel.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-07-01.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Overture

protocol RegisterCardViewModelInputs {
  var continueButton: PublishSubject<Void> { get }
  var registerCardLater: PublishSubject<Void> { get }
}

protocol RegisterCardViewModelOutputs {
}

protocol RegisterCardViewModelType: NavigationViewModelType {
  var inputs: RegisterCardViewModelInputs { get }
  var outputs: RegisterCardViewModelOutputs { get }
}

struct RegisterCardViewModel: RegisterCardViewModelType
  , RegisterCardViewModelInputs
, RegisterCardViewModelOutputs {
  
  // inputs
  let continueButton = PublishSubject<Void>()
  let registerCardLater = PublishSubject<Void>()
  
  // navigation
  let navigate: Observable<Void>
  
  init() {
    self.init(coordinator: SceneCoordinator.shared)
  }
  
  init(coordinator: SceneCoordinator) {
    let navigateContinue = continueButton.flatMapLatest {
      coordinator.transition(to: Scene.registrationCode(RegistrationCodeViewModel()))
    }.debug("Navigate continue", trimOutput: false)
    
    let navigateRegisterCardLater = registerCardLater.flatMapLatest {
      coordinator.transition(to: Scene.registrationCode(RegistrationCodeViewModel()))
    }.debug("Navigate register card later", trimOutput: false)
    
    navigate = Observable.merge(navigateContinue, navigateRegisterCardLater)
  }
  
  var inputs: RegisterCardViewModelInputs { return self }
  var outputs: RegisterCardViewModelOutputs { return self }
}
