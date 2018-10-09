//
//  RegisterCardViewController.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-14.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterCardViewController: UIViewController, ViewModelBindable {
  
  let disposeBag = DisposeBag()
  var viewModel: RegisterCardViewModelType!
  
  @IBOutlet weak var cardNumberTextField: UITextField!
  @IBOutlet weak var continueButton: UIButton!
  @IBOutlet weak var registerLaterButton: UIButton!
  
  override func viewDidLoad() {
    cardNumberTextField.becomeFirstResponder()
  }
  
  func bindViewModel() {
    continueButton.rx.tap
      .bind(to: viewModel.inputs.continueButton)
      .disposed(by: disposeBag)
    
    registerLaterButton.rx.tap
      .bind(to: viewModel.inputs.registerCardLater)
      .disposed(by: disposeBag)
  }
}
