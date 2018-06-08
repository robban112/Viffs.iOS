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

class LoginViewController: UIViewController {
  
    private let disposeBag = DisposeBag()
    private let viewModel: LoginViewModelType = LoginViewModel()

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
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
      
        Driver
          .combineLatest(corrEmail, corrPwd) { $0 && $1 }
          .distinctUntilChanged()
          .drive(loginButton.rx.isEnabled)
          .disposed(by: disposeBag)
    }
}
