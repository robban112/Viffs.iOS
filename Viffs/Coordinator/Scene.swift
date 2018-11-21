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
  case receiptDetail(ReceiptDetailViewModel)
  case registerCard
  case receiptCode
  case receipts([Card])
  case receiptsSorted()
  case mittViffs(MittViffsViewModel)
  case stores
  case scanReceipt
  case main
  case cards
  case settings
  case help
  case changeLanguage
  case store
}

extension Scene: TargetScene {
  var transition: SceneTransitionType {
    switch self {
    case .blipp:
      return .root(setupSideMenu())
    case .scanReceipt:
      let scanReceiptVC = ScanReceiptViewController.instantiateFromNib()
      scanReceiptVC.title = "Skanna kvitto"
      return .push(scanReceiptVC)
    case let .receiptDetail(receiptDetailViewModel):
      var receiptDetailVC = ReceiptDetailViewController.instantiateFromNib()
      receiptDetailVC.title = ""
      receiptDetailVC.bind(to: receiptDetailViewModel)
      return .push(receiptDetailVC)
    case .registerCard:
      let registerCardVC = RegisterCardViewController.instantiateFromNib()
      registerCardVC.title = "Registrera kort"
      return .push(registerCardVC)
    case .receipts(let cards):
      
      let receiptVC = ReceiptViewController.instantiateFromNib()
      receiptVC.cards = cards
      receiptVC.title = "Kvitton"
      return .push(receiptVC)
    case .receiptsSorted():
      let receiptVC = ReceiptViewController.instantiateFromNib()
        receiptVC.title = "Kvitton Sorterat"
        return .push(receiptVC)
    case let .mittViffs(mittViffsViewModel):
      var mittViffsVC = MittViffsViewController.instantiateFromNib()
      mittViffsVC.title = "Mitt Viffs"
      mittViffsVC.bind(to: mittViffsViewModel)
      return .push(mittViffsVC)
    case .stores:
      let storesVC = StoresViewController.instantiateFromNib()
      storesVC.title = "Butiker"
      return .push(storesVC)
    case .store:
      let storeVC = StoreViewController.instantiateFromNib()
      storeVC.title = "Butik" //Set to store name
      return .push(storeVC)
    case .main:
      let mainVC = MainViewController.instantiateFromNib()
      mainVC.title = "Hem"
      return .push(mainVC)
    case .cards:
      let cardsVC = CardsViewController.instantiateFromNib()
      cardsVC.title = "Kort"
      return .push(cardsVC)
    case .help:
      let helpVC = HelpViewController.instantiateFromNib()
      helpVC.title = "Hjälp"
      return .push(helpVC)
    case .settings:
      let settingsVC = SettingsViewController.instantiateFromNib()
      settingsVC.title = "Inställningar"
      return .push(settingsVC)
    case .changeLanguage:
      let changeLanguageVC = ChangeLanguageViewController.instantiateFromNib()
      changeLanguageVC.title = "Byt språk"
      return .push(changeLanguageVC)
    case .receiptCode:
      let receiptCodeVC = ReceiptCodeViewController.instantiateFromNib()
      receiptCodeVC.title = "Lägg till kort"
      return .push(receiptCodeVC)
    }
  }
}

/*
 Function responsible for creating main viewcontroller and more viewcontroller, with the side menu as the connection between.
 Returns the navigationcontroller of main
 */
func setupSideMenu() -> UINavigationController {
  // Define the menus
  let mainVC = MainViewController.instantiateFromNib()
  let mainNav = UINavigationController(rootViewController: mainVC)
  mainNav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
  mainNav.navigationBar.shadowImage = UIImage()
  let moreVC = MoreViewController.instantiateFromNib()
  mainVC.title = ""
  moreVC.title = ""
  let navRight = UISideMenuNavigationController(rootViewController: moreVC)
  navRight.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
  navRight.navigationBar.shadowImage = UIImage()
  SideMenuManager.default.menuRightNavigationController = navRight
  
  mainNav.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Montserrat-Regular", size: 18)!]

  // Enable gestures. The left and/or right menus must be set up above for these to work.
  // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
//  SideMenuManager.default.menuAddPanGestureToPresent(toView: navigationController!.navigationBar)
//  SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: navigationController!.view)
  
  // Set up a cool background image for demo purposes
  //SideMenuManager.default.menuAnimationBackgroundColor = UIColor(patternImage: UIImage(named: "background")!)
  
  return mainNav
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
