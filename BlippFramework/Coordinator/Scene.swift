//
//  Scene.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-10.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit

public protocol TargetScene {
  var transition: SceneTransitionType { get }
}

public enum Scene {
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
  public var transition: SceneTransitionType {
    switch self {
    case .blipp:
      let blippTabBarController = createBlippTabBarController()
      return .root(blippTabBarController)
    case let .login(loginViewModel):
      var loginVC = LoginViewController.instantiateFromNib()
      loginVC.title = "Logga in"
      loginVC.bind(to: loginViewModel)
      return .push(loginVC)
    case let .receiptDetail(receiptDetailViewModel):
      var receiptDetailVC = ReceiptDetailViewController.instantiateFromNib()
      receiptDetailVC.title = "Detaljerad info"
      receiptDetailVC.bind(to: receiptDetailViewModel)
      return .push(receiptDetailVC)
    case let .registerUser(registerUserViewModel):
      var registerUserVC = RegisterUserViewController.instantiateFromNib()
      registerUserVC.title = "Ny användare"
      registerUserVC.bind(to: registerUserViewModel)
      return .push(registerUserVC)
    case let .registerCard(registerCardViewModel):
      var registerCardVC = RegisterCardViewController.instantiateFromNib()
      registerCardVC.bind(to: registerCardViewModel)
      registerCardVC.title = "Kortinformation"
      return .push(registerCardVC)
    case let .registrationCode(registrationCodeViewModel):
      var registrationCodeVC = RegistrationCodeViewController.instantiateFromNib()
      registrationCodeVC.bind(to: registrationCodeViewModel)
      registrationCodeVC.title = "Registreringskod"
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
    case let .welcome(welcomeViewModel):
      var welcomeVC = WelcomeViewController.instantiateFromNib()
      welcomeVC.bind(to: welcomeViewModel)
      welcomeVC.title = "Välkommen till Blipp!"
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
