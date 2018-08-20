//
//  HomeViewController.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-14.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Overture

class HomeViewController: UIViewController, ViewModelBindable {
  let disposeBag = DisposeBag()
  // will be set by Coordinator
  var viewModel: HomeViewModelType!
  
  @IBOutlet weak var receiptsButton: UIButton!
  @IBOutlet weak var storesButton: UIButton!
  
  func bindViewModel() {
    bindUIToViewModel()
  }
  
  func bindUIToViewModel() {
    
    let cardBarButton = UIBarButtonItem(image: .bundledImage(#imageLiteral(resourceName: "card25x25")), style: .plain, target: nil, action: nil)
    navigationItem.setRightBarButton(cardBarButton, animated: false)
    
    cardBarButton.rx.tap
      .bind(to: viewModel.inputs.addCard)
      .disposed(by: disposeBag)
    
    receiptsButton.rx.tap
      .bind(to: viewModel.inputs.receipts)
      .disposed(by: disposeBag)
    
    storesButton.rx.tap
      .bind(to: viewModel.inputs.stores)
      .disposed(by: disposeBag)
  }
}
