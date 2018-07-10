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

public protocol RegistrationCodeViewModelInputs {
  var continueButton: PublishSubject<Void> { get }
}

public protocol RegistrationCodeViewModelOutputs {
}

public protocol RegistrationCodeViewModelType: NavigationViewModelType {
  var inputs: RegistrationCodeViewModelInputs { get }
  var outputs: RegistrationCodeViewModelOutputs { get }
}

public struct RegistrationCodeViewModel: RegistrationCodeViewModelType
  , RegistrationCodeViewModelInputs
, RegistrationCodeViewModelOutputs {
  
  // inputs
  public let continueButton = PublishSubject<Void>()
  
  // navigation
  public let navigate: Observable<Void>
  
  public init() {
    self.init(coordinator: SceneCoordinator.shared)
  }
  
  public init(coordinator: SceneCoordinator) {
    let navigateContinue = continueButton.flatMapLatest {
      coordinator.transition(to: Scene.blipp)
    }
    
    navigate = navigateContinue
  }
  
  public var inputs: RegistrationCodeViewModelInputs { return self }
  public var outputs: RegistrationCodeViewModelOutputs { return self }
}
