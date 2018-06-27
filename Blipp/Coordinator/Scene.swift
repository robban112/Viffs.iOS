//
//  Scene.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-10.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit

protocol TargetScene {
  var transition: SceneTransitionType { get }
}

enum Scene {
  case blipp
  case login(LoginViewModel)
  case receiptDetail(ReceiptDetailViewModel)
  case registerUser(RegisterUserViewModel)
  case registerCard
  case registrationCode
  case receipts(ReceiptViewModel)
  case receiptsSorted(ReceiptViewModel)
  case receiptsRoot
  case stores
  case scanReceipt
}

extension Scene: TargetScene {
  var transition: SceneTransitionType {
    switch self {
    case .blipp:
      let blippTabBarController = createBlippTabBarController()
      return .root(blippTabBarController)
    case let .login(loginViewModel):
      var loginVC = LoginViewController.instantiateFromNib()
      loginVC.bind(to: loginViewModel)
      return .root(loginVC)
    case let .receiptDetail(receiptDetailViewModel):
      var receiptDetailVC = ReceiptDetailViewController.instantiateFromNib()
      receiptDetailVC.bind(to: receiptDetailViewModel)
      return .push(receiptDetailVC)
    case let .registerUser(registerUserViewModel):
      var registerUserVC = RegisterUserViewController.instantiateFromNib()
      registerUserVC.bind(to: registerUserViewModel)
      return .root(registerUserVC)
    case .registerCard:
      let registerCardVC = RegisterCardViewController.instantiateFromNib()
      return .push(registerCardVC)
    case .registrationCode:
      let registrationCodeVC = RegistrationCodeViewController.instantiateFromNib()
      return .push(registrationCodeVC)
    case let .receipts(receiptViewModel):
      var receiptVC = ReceiptViewController.instantiateFromNib()
      receiptVC.title = "Alla kvitton"
      receiptVC.bind(to: receiptViewModel)
      return .push(receiptVC)
    case let .receiptsSorted(receiptViewModel):
        var receiptVC = ReceiptViewController.instantiateFromNib()
        receiptVC.title = "Sorterade kvitton"
        receiptVC.bind(to: receiptViewModel)
        return .push(receiptVC)
    case .receiptsRoot:
      let receiptsRootVC = ReceiptsRootViewController.instantiateFromNib()
      return .push(receiptsRootVC)
    case .stores:
      let storesVC = StoresViewController.instantiateFromNib()
      storesVC.title = "Butiker"
      return .push(storesVC)
    case .scanReceipt:
      let scanReceiptVC = ScanReceiptViewController.instantiateFromNib()
      scanReceiptVC.title = "Scanna kvitto"
      return .push(scanReceiptVC)
    }
  }
}

func createBlippTabBarController() -> UITabBarController {
  let blippTabBarController = UITabBarController()
  
  var homeVC = HomeViewController.instantiateFromNib()
  homeVC.bind(to: HomeViewModel())
  homeVC.title = "Hem"
  let homeNav = UINavigationController(rootViewController: homeVC)
  homeNav.tabBarItem = UITabBarItem(title: "Hem", image: #imageLiteral(resourceName: "home25x25"), tag: 0)
  
  var receiptsRootVC = ReceiptsRootViewController.instantiateFromNib()
  receiptsRootVC.bind(to: ReceiptsRootViewModel())
  receiptsRootVC.title = "Kvitton"
  let receiptsNav = UINavigationController(rootViewController: receiptsRootVC)
  receiptsNav.tabBarItem = UITabBarItem(title: "Kvitton", image: #imageLiteral(resourceName: "receipt25x25"), tag: 1)
  
  let storesVC = StoresViewController.instantiateFromNib()
  storesVC.title = "Butiker"
  let storesNav = UINavigationController(rootViewController: storesVC)
  storesNav.tabBarItem = UITabBarItem(title: "Butiker", image: #imageLiteral(resourceName: "shop25x25"), tag: 2)
  
  let moreVC = MoreViewController.instantiateFromNib()
  moreVC.title = "Mer"
  let moreNav = UINavigationController(rootViewController: moreVC)
  moreVC.tabBarItem = UITabBarItem(title: "Mer", image: nil, tag: 3)
  
  blippTabBarController.viewControllers = [ homeNav, receiptsNav, storesNav, moreNav ]
  
  return blippTabBarController
}
