//
//  RegistrationCodeViewController.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-14.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegistrationCodeViewController: UIViewController, ViewModelBindable {
  
  let disposeBag = DisposeBag()
  var viewModel: RegistrationCodeViewModelType!
  
  @IBOutlet weak var continueButton: UIButton!
  
  func bindViewModel() {
    continueButton.rx.tap
      .bind(to: viewModel.inputs.continueButton)
      .disposed(by: disposeBag)
  }
}
