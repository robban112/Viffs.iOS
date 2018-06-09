//
//  Coordinator.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-08.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import RxSwift

struct Coordinator {
  
  let disposeBag = DisposeBag()
  let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
  
  // ViewControllers
  let rootTabBarController: UITabBarController
  let receiptViewController: ReceiptViewController
  let loginViewController: LoginViewController
  
  // ViewModels
  let receiptViewModel = ReceiptViewModel()
  let loginViewModel = LoginViewModel()
  
  init(rootTabBarController: UITabBarController) {
    self.rootTabBarController = rootTabBarController
    receiptViewController = rootTabBarController.viewControllers?[0] as! ReceiptViewController
    loginViewController = rootTabBarController.viewControllers?[2] as! LoginViewController
    receiptViewController.viewModel = receiptViewModel
    loginViewController.viewModel = loginViewModel
    
    setUpNavigationBindings()
  }
  
  func setUpNavigationBindings() {
    receiptViewModel.receiptDetailNavigation
      .subscribe(onNext: presentReceiptDetail)
      .disposed(by: disposeBag)
  }
  
  func presentReceiptDetail(for receipt: Receipt) {
    let detailViewController = storyboard
      .instantiateViewController(withIdentifier: "ReceiptDetail") as! ReceiptDetailViewController
    let detailViewModel = ReceiptDetailViewModel(receipt: receipt)
    detailViewController.viewModel = detailViewModel
    detailViewModel.navigation.backNavigation
      .subscribe(onNext: dismissReceiptDetail)
      .disposed(by: detailViewController.disposeBag)
    self.receiptViewController.present(detailViewController, animated: true, completion: nil)
  }
  
  func dismissReceiptDetail() {
    receiptViewController.dismiss(animated: true)
  }
}
