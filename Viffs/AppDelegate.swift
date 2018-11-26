//
//  AppDelegate.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-05-15.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import SideMenu

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var signInViewController: SignInViewController?
  var mfaViewController: MFAViewController?
  var navigationController: UINavigationController?
  var storyboard: UIStoryboard?
  var rememberDeviceCompletionSource: AWSTaskCompletionSource<NSNumber>?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    Current.loginManager.initialize()
    return true
  }
}
