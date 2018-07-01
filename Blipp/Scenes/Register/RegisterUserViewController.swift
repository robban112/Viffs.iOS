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

func textFieldRightView(for inputState: InputState) -> UIView? {
  switch inputState {
  case .unInitiated: return .none
  case .illFormed: return UIImageView(image: #imageLiteral(resourceName: "red_cross"))
  case .wellFormed: return UIImageView(image: #imageLiteral(resourceName: "green_tick"))
  }
}

class RegisterUserViewController: UIViewController, ViewModelBindable {
  
  let disposeBag = DisposeBag()
  var viewModel: RegisterUserViewModelType!

  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!
  @IBOutlet var createAccountButton: UIButton!
  
  override func viewDidLoad() {
    emailTextField.becomeFirstResponder()
  }
  
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
      .map(textFieldRightView(for:))
      .drive(emailTextField.rx.rightView)
      .disposed(by: disposeBag)
    
    viewModel.outputs.passwordState
      .map(textFieldRightView(for:))
      .drive(passwordTextField.rx.rightView)
      .disposed(by: disposeBag)
    
    viewModel.outputs.registerButtonEnabled
      .drive(createAccountButton.rx.isEnabled)
      .disposed(by: disposeBag)
  }
}
