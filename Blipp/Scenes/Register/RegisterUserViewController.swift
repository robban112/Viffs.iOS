//
//  RegisterUserViewController.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-05-24.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import RxSwift

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
    let corrEmail = viewModel.outputs.correctEmail
    let corrPwd = viewModel.outputs.correctPassword
    
    corrEmail
      .map { $0 ? .green : .red }
      .drive(self.emailTextField.rx.backgroundColor)
      .disposed(by: disposeBag)
    
    corrPwd
      .map { $0 ? .green : .red }
      .drive(self.passwordTextField.rx.backgroundColor)
      .disposed(by: disposeBag)
  }
}
