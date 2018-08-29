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
  case registerCard(RegisterCardViewModel)
  case registrationCode(RegistrationCodeViewModel)
  case receipts(ReceiptViewModel)
  case receiptsSorted(ReceiptViewModel)
  case receiptsRoot
  case stores
  case scanReceipt
  case welcome(WelcomeViewModel)
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
      return .push(loginVC)
    case let .receiptDetail(receiptDetailViewModel):
      var receiptDetailVC = ReceiptDetailViewController.instantiateFromNib()
      receiptDetailVC.bind(to: receiptDetailViewModel)
      return .push(receiptDetailVC)
    case let .registerUser(registerUserViewModel):
      var registerUserVC = RegisterUserViewController.instantiateFromNib()
      registerUserVC.bind(to: registerUserViewModel)
      return .push(registerUserVC)
    case let .registerCard(registerCardViewModel):
      var registerCardVC = RegisterCardViewController.instantiateFromNib()
      registerCardVC.bind(to: registerCardViewModel)
      return .push(registerCardVC)
    case let .registrationCode(registrationCodeViewModel):
      var registrationCodeVC = RegistrationCodeViewController.instantiateFromNib()
      registrationCodeVC.bind(to: registrationCodeViewModel)
      return .push(registrationCodeVC)
    case let .receipts(receiptViewModel):
      var receiptVC = ReceiptViewController.instantiateFromNib()
      receiptVC.bind(to: receiptViewModel)
      return .push(receiptVC)
    case let .receiptsSorted(receiptViewModel):
        var receiptVC = ReceiptViewController.instantiateFromNib()
        receiptVC.bind(to: receiptViewModel)
        return .push(receiptVC)
    case .receiptsRoot:
      let receiptsRootVC = ReceiptsRootViewController.instantiateFromNib()
      return .push(receiptsRootVC)
    case .stores:
      let storesVC = StoresViewController.instantiateFromNib()
      return .push(storesVC)
    case .scanReceipt:
      let scanReceiptVC = ScanReceiptViewController.instantiateFromNib()
      return .push(scanReceiptVC)
    case let .welcome(welcomeViewModel):
      var welcomeVC = WelcomeViewController.instantiateFromNib()
      welcomeVC.bind(to: welcomeViewModel)
      let welcomeNav = UINavigationController(rootViewController: welcomeVC)
      
      // make navigation bar invisible
      welcomeNav.navigationBar.backgroundColor = .clear
      welcomeNav.navigationBar.setBackgroundImage(.init(), for: .default)
      welcomeNav.navigationBar.shadowImage = .init()
      welcomeNav.navigationBar.isTranslucent = true
      welcomeNav.view.backgroundColor = welcomeNav.navigationBar.barTintColor
      
      return .root(welcomeNav)
    }
  }
}

fileprivate func createBlippTabBarController() -> UITabBarController {
  let blippTabBarController = UITabBarController()
  
  var homeVC = HomeViewController.instantiateFromNib()
  homeVC.bind(to: HomeViewModel())
  homeVC.title = ""
  let homeNav = UINavigationController(rootViewController: homeVC)
  homeNav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
  homeNav.navigationBar.shadowImage = UIImage()
  homeNav.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "home25x25"), tag: 0)
  
  let moreVC = MoreViewController.instantiateFromNib()
  let moreNav = UINavigationController(rootViewController: moreVC)
  moreVC.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "menu"), tag: 1)
  
  blippTabBarController.viewControllers = [ homeNav, moreNav ]
  
  return blippTabBarController
}
