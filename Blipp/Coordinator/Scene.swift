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
  case receiptDetail(ReceiptDetailViewModel)
  case registerUser(RegisterUserViewModel)
}

extension Scene: TargetScene {
  var transition: SceneTransitionType {
    switch self {
    case .blipp:
      let blippTabBarController = createBlippTabBarController()
      return .root(blippTabBarController)
    case let .receiptDetail(receiptDetailViewModel):
      var receiptDetailVC = ReceiptDetailViewController.instantiateFromNib()
      receiptDetailVC.bind(to: receiptDetailViewModel)
      return .push(receiptDetailVC)
    case let .registerUser(registerUserViewModel):
      var registerUserVC = RegisterUserViewController.instantiateFromNib()
      registerUserVC.bind(to: registerUserViewModel)
      return .push(registerUserVC)
    }
  }
}

func createBlippTabBarController() -> UITabBarController {
  let blippTabBarController = UITabBarController()
  
  var receiptVC = ReceiptViewController.instantiateFromNib()
  receiptVC.bind(to: ReceiptViewModel())
  let rootReceiptVC = UINavigationController(rootViewController: receiptVC)
  
  var loginVC = LoginViewController.instantiateFromNib()
  loginVC.bind(to: LoginViewModel())
  let rootLoginVC = UINavigationController(rootViewController: loginVC)
  
  rootReceiptVC.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.recents, tag: 0)
  rootLoginVC.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 1)
  
  blippTabBarController.viewControllers = [ rootReceiptVC, rootLoginVC ]
  
  return blippTabBarController
}
