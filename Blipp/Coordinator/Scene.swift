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
  case receipt(ReceiptViewModel)
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
      return .push(registerUserVC)
    case .registerCard:
      let registerCardVC = RegisterCardViewController.instantiateFromNib()
      return .push(registerCardVC)
    case .registrationCode:
      let registrationCodeVC = RegistrationCodeViewController.instantiateFromNib()
      return .push(registrationCodeVC)
    case let .receipt(receiptViewModel):
      var receiptVC = ReceiptViewController.instantiateFromNib()
      receiptVC.title = "Alla kvitton"
      receiptVC.bind(to: receiptViewModel)
      return .push(receiptVC)
    }
  }
}

func createBlippTabBarController() -> UITabBarController {
  let blippTabBarController = UITabBarController()
  
  let homeVC = HomeViewController.instantiateFromNib()
  homeVC.tabBarItem = UITabBarItem(title: "Hem", image: #imageLiteral(resourceName: "home25x25"), tag: 0)
  
  let receiptsRootVC = ReceiptsRootViewController.instantiateFromNib()
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
  
  blippTabBarController.viewControllers = [ homeVC, receiptsNav, storesNav, moreNav ]
  
  return blippTabBarController
}
