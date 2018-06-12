//
//  RegisterUserViewController.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-05-24.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import RxSwift

// get the text field background color for a given inputState
func backgroundColor(for inputState: InputState) -> UIColor? {
  switch inputState {
  case .unInitiated: return .none
  case .illFormed: return .some(.red)
  case .wellFormed: return .some(.green)
  }
}

class RegisterUserViewController: UIViewController, ViewModelBindable {
  
  let disposeBag = DisposeBag()
  var viewModel: RegisterUserViewModelType!

  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!
  @IBOutlet var createAccountButton: UIButton!
  
  func bindViewModel() {
    bindUIToViewModel()
    bindViewModelToUI()
  }
  
  func bindUIToViewModel() {
    emailTextField.rx.text.orEmpty
      .bind(to: viewModel.inputs.emailString)
      .disposed(by: disposeBag)
    
    passwordTextField.rx.text.orEmpty
      .bind(to: viewModel.inputs.passwordString)
      .disposed(by: disposeBag)
    
    createAccountButton.rx.tap
      .bind(to: viewModel.inputs.createAccount)
      .disposed(by: disposeBag)
  }
  
  func bindViewModelToUI() {
    viewModel.outputs.emailState
      .map(backgroundColor(for:))
      .drive(emailTextField.rx.backgroundColor)
      .disposed(by: disposeBag)

    viewModel.outputs.passwordState
      .map(backgroundColor(for:))
      .drive(passwordTextField.rx.backgroundColor)
      .disposed(by: disposeBag)
  }
}
