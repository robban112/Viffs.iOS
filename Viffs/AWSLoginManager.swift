//
//  AWSLoginManager.swift
//  Viffs
//
//  Created by Robert Lorentz on 2018-10-16.
//  Copyright © 2018 Viffs. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider
import PromiseKit

var LoginManager = AWSLoginManager()

class AWSLoginManager: NSObject {
  
  var storyboard: UIStoryboard!
  var navigationController: UINavigationController?
  var signInViewController: SignInViewController?
  var rememberDeviceCompletionSource: AWSTaskCompletionSource<NSNumber>?
  var window: UIWindow?
  var mfaViewController: MFAViewController?

  var pool: AWSCognitoIdentityUserPool? = nil
 
  func updateUserDetails(pool: AWSCognitoIdentityUserPool) {
    Current.pool = pool
    Current.AWSUser = pool.currentUser()
    let _ = pool.currentUser()
  }
  
  func getSession(){
    Current.AWSUser?.getSession().continueOnSuccessWith { (getSessionTask) -> AnyObject? in
      DispatchQueue.main.async(execute: {
        let getSessionResult = getSessionTask.result
        
        //let idToken = getSessionResult?.idToken?.tokenString
        if let accessToken = getSessionResult?.accessToken?.tokenString {
          setReceiptsForUser(token: accessToken)
          setStores()
          setOffers()
          setCards()
          Current.accessToken = accessToken
          print("Accesstoken: " + accessToken)
        }
      })
      return nil
    }
  }
  
  func setInitialViewController() {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    //    let main = MainViewController.instantiateFromNib()
    //    let nav = UINavigationController(rootViewController: main)
    //    self.window?.rootViewController = nav
    self.window?.makeKeyAndVisible()
    self.window?.rootViewController = UIViewController()
    let coordinator = SceneCoordinator(window: window!, storyboard: storyboard!)
    SceneCoordinator.shared = coordinator
    _ = coordinator.transition(to: Scene.blipp)
  }
  
  func initialize() {
    // setup logging
    AWSDDLog.sharedInstance.logLevel = .verbose
    
    // setup service configuration
    let serviceConfiguration = AWSServiceConfiguration(region: CognitoIdentityUserPoolRegion, credentialsProvider: nil)
    
    // create pool configuration
    let poolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: CognitoIdentityUserPoolAppClientId,
                                                                    clientSecret: CognitoIdentityUserPoolAppClientSecret,
                                                                    poolId: CognitoIdentityUserPoolId)
    
    // initialize user pool client
    AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: poolConfiguration, forKey: AWSCognitoUserPoolsSignInProviderKey)
    
    // fetch the user pool client we initialized in above step
    let pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)
    self.storyboard = UIStoryboard(name: "AWS", bundle: nil)
    pool.delegate = self
    Current.pool = pool
    
    // Initialize the Amazon Cognito credentials provider
    let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
                                                            identityPoolId:"us-east-1:b022e33e-7f9a-404f-9874-2def6ce79c2e")
    
    let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
    
    AWSServiceManager.default().defaultServiceConfiguration = configuration
    
    setInitialViewController()
    LoginManager.updateUserDetails(pool: pool)
    updateUserDetails(pool: pool)
    getSession()
  }
}

extension AWSLoginManager: AWSCognitoIdentityInteractiveAuthenticationDelegate {
  func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
    if (self.navigationController == nil) {
      self.navigationController = self.storyboard?.instantiateViewController(withIdentifier: "signinController") as? UINavigationController
    }

    if (self.signInViewController == nil) {
      self.signInViewController = self.navigationController?.viewControllers[0] as? SignInViewController
    }

    DispatchQueue.main.async {
      self.navigationController!.popToRootViewController(animated: true)
      if (!self.navigationController!.isViewLoaded
        || self.navigationController!.view.window == nil) {
        self.window?.rootViewController?.present(self.navigationController!,
                                                 animated: true,
                                                 completion: nil)
      }

    }
    return self.signInViewController!
  }

  func startMultiFactorAuthentication() -> AWSCognitoIdentityMultiFactorAuthentication {
    if (self.mfaViewController == nil) {
      self.mfaViewController = MFAViewController()
      self.mfaViewController?.modalPresentationStyle = .popover
    }
    DispatchQueue.main.async {
      if (!self.mfaViewController!.isViewLoaded
        || self.mfaViewController!.view.window == nil) {
        //display mfa as popover on current view controller
        let viewController = self.window?.rootViewController!
        viewController?.present(self.mfaViewController!,
                                animated: true,
                                completion: nil)

        // configure popover vc
        let presentationController = self.mfaViewController!.popoverPresentationController
        presentationController?.permittedArrowDirections = UIPopoverArrowDirection.left
        presentationController?.sourceView = viewController!.view
        presentationController?.sourceRect = viewController!.view.bounds
      }
    }
    return self.mfaViewController!
  }

  func startRememberDevice() -> AWSCognitoIdentityRememberDevice {
    return self
  }
}

// MARK:- AWSCognitoIdentityRememberDevice protocol delegate

extension AWSLoginManager: AWSCognitoIdentityRememberDevice {
  
  func getRememberDevice(_ rememberDeviceCompletionSource: AWSTaskCompletionSource<NSNumber>) {
    self.rememberDeviceCompletionSource = rememberDeviceCompletionSource
    DispatchQueue.main.async {
      // dismiss the view controller being present before asking to remember device
      self.window?.rootViewController!.presentedViewController?.dismiss(animated: true, completion: nil)
      let alertController = UIAlertController(title: "Remember Device",
                                              message: "Do you want to remember this device?.",
                                              preferredStyle: .actionSheet)
      
      let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
        self.rememberDeviceCompletionSource?.set(result: true)
      })
      let noAction = UIAlertAction(title: "No", style: .default, handler: { (action) in
        self.rememberDeviceCompletionSource?.set(result: false)
      })
      alertController.addAction(yesAction)
      alertController.addAction(noAction)
      
      self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
  }
  
  func didCompleteStepWithError(_ error: Error?) {
    DispatchQueue.main.async {
      if let error = error as NSError? {
        let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                message: error.userInfo["message"] as? String,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        DispatchQueue.main.async {
          self.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
      }
    }
  }
}
