//
//  ReceiptsRootViewController.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-14.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Overture

class ReceiptsRootViewController: UIViewController, ViewModelBindable {
    let disposeBag = DisposeBag()
    // will be set by Coordinator
    var viewModel: ReceiptsRootViewModelType!
    
    @IBOutlet weak var receiptsButton: UIButton!
    @IBOutlet weak var sortedButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    
    
    func bindViewModel() {
        bindUIToViewModel()
    }
    
    func bindUIToViewModel() {
        
        receiptsButton.rx.tap
            .bind(to: viewModel.inputs.receipts)
            .disposed(by: disposeBag)
        
        sortedButton.rx.tap
            .bind(to: viewModel.inputs.sorted)
            .disposed(by: disposeBag)
        
        scanButton.rx.tap
            .bind(to: viewModel.inputs.scan) 
            .disposed(by: disposeBag)
    }
}

