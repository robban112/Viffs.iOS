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

public protocol RegisterCardViewModelInputs {
  var continueButton: PublishSubject<Void> { get }
  var registerCardLater: PublishSubject<Void> { get }
}

public protocol RegisterCardViewModelOutputs {
}

public protocol RegisterCardViewModelType: NavigationViewModelType {
  var inputs: RegisterCardViewModelInputs { get }
  var outputs: RegisterCardViewModelOutputs { get }
}

public struct RegisterCardViewModel: RegisterCardViewModelType
  , RegisterCardViewModelInputs
, RegisterCardViewModelOutputs {
  
  // inputs
  public let continueButton = PublishSubject<Void>()
  public let registerCardLater = PublishSubject<Void>()
  
  // navigation
  public let navigate: Observable<Void>
  
  public init() {
    self.init(coordinator: SceneCoordinator.shared)
  }
  
  public init(coordinator: SceneCoordinator) {
    let navigateContinue = continueButton.flatMapLatest {
      coordinator.transition(to: Scene.registrationCode(RegistrationCodeViewModel()))
    }.debug("Navigate continue", trimOutput: false)
    
    let navigateRegisterCardLater = registerCardLater.flatMapLatest {
      coordinator.transition(to: Scene.registrationCode(RegistrationCodeViewModel()))
    }.debug("Navigate register card later", trimOutput: false)
    
    navigate = Observable.merge(navigateContinue, navigateRegisterCardLater)
  }
  
  public var inputs: RegisterCardViewModelInputs { return self }
  public var outputs: RegisterCardViewModelOutputs { return self }
}
