//
//  LoginViewController.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-05-23.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Overture

class LoginViewController: UIViewController, ViewModelBindable {
  
  let disposeBag = DisposeBag()
  // vill be set by Coordinator
  var viewModel: LoginViewModelType!
  
  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var registerButton: UIButton!
  
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
    
    loginButton.rx.tap
      .bind(to: viewModel.inputs.login)
      .disposed(by: disposeBag)
    
    registerButton.rx.tap
      .bind(to: viewModel.inputs.registerUser)
      .disposed(by: disposeBag)
  }
  
  func bindViewModelToUI() {
    viewModel.outputs.loginButtonEnabled
      .drive(loginButton.rx.isEnabled)
      .disposed(by: disposeBag)
  }
}