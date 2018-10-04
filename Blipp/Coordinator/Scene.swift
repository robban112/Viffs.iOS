//
//  Scene.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-10.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import SideMenu

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
  case main
  case welcome(WelcomeViewModel)
}

extension Scene: TargetScene {
  var transition: SceneTransitionType {
    switch self {
    case .blipp:
//      let main = MainViewController.instantiateFromNib()
//      let nav = UISideMenuNavigationController(rootViewController: main)
//      main.title = ""
//      return .push(nav)
      let blippTabBarController = createBlippTabBarController()
      return .root(blippTabBarController)
    case let .login(loginViewModel):
      var loginVC = LoginViewController.instantiateFromNib()
      loginVC.title = ""
      loginVC.bind(to: loginViewModel)
      return .push(loginVC)
    case .scanReceipt:
      let scanReceiptVC = ScanReceiptViewController.instantiateFromNib()
      scanReceiptVC.title = ""
      return .push(scanReceiptVC)
    case let .receiptDetail(receiptDetailViewModel):
      var receiptDetailVC = ReceiptDetailViewController.instantiateFromNib()
      receiptDetailVC.title = ""
      receiptDetailVC.bind(to: receiptDetailViewModel)
      return .push(receiptDetailVC)
    case let .registerUser(registerUserViewModel):
      var registerUserVC = RegisterUserViewController.instantiateFromNib()
      registerUserVC.title = ""
      registerUserVC.bind(to: registerUserViewModel)
      return .push(registerUserVC)
    case let .registerCard(registerCardViewModel):
      var registerCardVC = RegisterCardViewController.instantiateFromNib()
      registerCardVC.title = ""
      registerCardVC.bind(to: registerCardViewModel)
      return .push(registerCardVC)
    case let .registrationCode(registrationCodeViewModel):
      var registrationCodeVC = RegistrationCodeViewController.instantiateFromNib()
      registrationCodeVC.title = ""
      registrationCodeVC.bind(to: registrationCodeViewModel)
      return .push(registrationCodeVC)
    case let .receipts(receiptViewModel):
      var receiptVC = ReceiptViewController.instantiateFromNib()
      receiptVC.title = ""
      receiptVC.bind(to: receiptViewModel)
      return .push(receiptVC)
    case let .receiptsSorted(receiptViewModel):
        var receiptVC = ReceiptViewController.instantiateFromNib()
        receiptVC.title = ""
        receiptVC.bind(to: receiptViewModel)
        return .push(receiptVC)
    case .receiptsRoot:
      let receiptsRootVC = ReceiptsRootViewController.instantiateFromNib()
      receiptsRootVC.title = ""
      return .push(receiptsRootVC)
    case .stores:
      let storesVC = StoresViewController.instantiateFromNib()
      storesVC.title = ""
      return .push(storesVC)
    case .main:
      let mainVC = MainViewController.instantiateFromNib()
      mainVC.title = ""
      return .push(mainVC)
    case .scanReceipt:
      let scanReceiptVC = ScanReceiptViewController.instantiateFromNib()
      scanReceiptVC.title = ""
      return .push(scanReceiptVC)
    case let .welcome(welcomeViewModel):
      var welcomeVC = WelcomeViewController.instantiateFromNib()
      welcomeVC.title = ""
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

  let homeVC = MainViewController.instantiateFromNib()
  homeVC.title = ""
  let homeNav = UINavigationController(rootViewController: homeVC)
  homeNav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
  homeNav.navigationBar.shadowImage = UIImage()
  homeNav.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "home30x30"), tag: 0)
  homeNav.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
  
  let moreVC = MoreViewController.instantiateFromNib()
  let moreNav = UINavigationController(rootViewController: moreVC)
  moreVC.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "menu30x30"), tag: 1)
  moreVC.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
  
  blippTabBarController.viewControllers = [ homeNav, moreNav ]
  
  return blippTabBarController
}
