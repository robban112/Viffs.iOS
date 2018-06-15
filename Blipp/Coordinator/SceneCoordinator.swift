//
//  SceneCoordinator.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-10.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/**
 Scene coordinator, manage scene navigation and presentation.
 */
class SceneCoordinator: NSObject, SceneCoordinatorType {
  
  static var shared: SceneCoordinator!
  
  private var window: UIWindow
  private var currentViewController: UIViewController {
    didSet {
      currentViewController.navigationController?.rx.delegate
        .setForwardToDelegate(self, retainDelegate: false)
      currentViewController.tabBarController?.rx.delegate
        .setForwardToDelegate(self, retainDelegate: false)
    }
  }
  
  required init(window: UIWindow) {
    self.window = window
    currentViewController = window.rootViewController ?? UIViewController()
  }
  
  @discardableResult
  func transition(to scene: TargetScene) -> Observable<Void> {
    let subject = PublishSubject<Void>()
    
    switch scene.transition {
    case let .root(viewController):
      currentViewController = displayedViewController(within: viewController)
      window.rootViewController = viewController
      subject.onCompleted()
    case let .push(viewController):
      guard let navigationController = currentViewController.navigationController else {
        fatalError("Can't push a view controller without a current navigation controller")
      }
      
      _ = navigationController.rx.delegate
        .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
        .map { _ in }
        .bind(to: subject)
      
      navigationController.pushViewController(displayedViewController(within: viewController), animated: true)
      currentViewController = displayedViewController(within: viewController)
    case let .present(viewController):
      currentViewController.present(viewController, animated: true) {
        subject.onCompleted()
      }
      currentViewController = displayedViewController(within: viewController)
    case let .alert(viewController):
      currentViewController.present(viewController, animated: true) {
        subject.onCompleted()
      }
    }
    
    return subject.asObservable()
      .take(1)
  }
  
  @discardableResult
  func pop(animated: Bool) -> Observable<Void> {
    let subject = PublishSubject<Void>()
    if let presentingViewController = currentViewController.presentingViewController {
      currentViewController.dismiss(animated: animated) {
        self.currentViewController = displayedViewController(within: presentingViewController)
        subject.onCompleted()
      }
    } else if let navigationController = currentViewController.navigationController {
      
      _ = navigationController
        .rx
        .delegate
        .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
        .map { _ in }
        .bind(to: subject)
      
      guard navigationController.popViewController(animated: animated) != nil else {
        fatalError("can't navigate back from \(currentViewController)")
      }
      
      currentViewController = displayedViewController(within: navigationController.viewControllers.last!)
    } else {
      fatalError("Not a modal, no navigation controller: can't navigate back from \(currentViewController)")
    }
    
    return subject.asObservable()
      .take(1)
  }
}

// MARK: - UINavigationControllerDelegate

extension SceneCoordinator: UINavigationControllerDelegate {
  func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    currentViewController = displayedViewController(within: viewController)
  }
}

// MARK: - UITabBarControllerDelegate

extension SceneCoordinator: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)  {
    currentViewController = displayedViewController(within: viewController)
  }
}

// MARK: - Extensions

/// Get the view controller currently in view within the view controller
fileprivate func displayedViewController(within viewController: UIViewController) -> UIViewController {
  switch viewController {
  case let navVC as UINavigationController:
    return navVC.viewControllers.first.flatMap(displayedViewController(within:)) ?? viewController
  case let tabVC as UITabBarController:
    return tabVC.selectedViewController.flatMap(displayedViewController(within:)) ?? viewController
  default:
    return viewController
  }
}
