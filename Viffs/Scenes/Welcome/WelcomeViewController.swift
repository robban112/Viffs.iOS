//
//  WelcomeViewController.swift
//  Blipp
//
//  Created by Kristofer Pitkäjärvi on 2018-06-29.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class WelcomeViewController: UIViewController, ViewModelBindable {
    
    let disposeBag = DisposeBag()
    var viewModel: WelcomeViewModelType!
    
    @IBOutlet var registerUserButton: UIButton!
    @IBOutlet var loginButton: UIButton!
    
    func bindViewModel() {
        bindUIToViewModel()
    }
    
    func bindUIToViewModel() {
        
        registerUserButton.rx.tap
            .bind(to: viewModel.inputs.registerUser)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to: viewModel.inputs.login)
            .disposed(by: disposeBag)
    }
}
