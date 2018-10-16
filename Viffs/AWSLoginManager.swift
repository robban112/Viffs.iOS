////
////  AWSLoginManager.swift
////  Viffs
////
////  Created by Robert Lorentz on 2018-10-16.
////  Copyright © 2018 Viffs. All rights reserved.
////
//
//import Foundation
//import AWSCognitoIdentityProvider
//
//class AWSLoginManager {
//  
//  static var shared: AWSLoginManager!
//  var pool: AWSCognitoIdentityUserPool? = nil
//  
//  func updateUserDetails(pool: AWSCognitoIdentityUserPool) {
//    Current.pool = pool
//    Current.currentAWSUser = pool.currentUser()
//    let user = pool.currentUser()
//  }
//  
//  func initialize() {
//    // setup logging
//    AWSDDLog.sharedInstance.logLevel = .verbose
//    
//    // setup service configuration
//    let serviceConfiguration = AWSServiceConfiguration(region: CognitoIdentityUserPoolRegion, credentialsProvider: nil)
//    
//    // create pool configuration
//    let poolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: CognitoIdentityUserPoolAppClientId,
//                                                                    clientSecret: CognitoIdentityUserPoolAppClientSecret,
//                                                                    poolId: CognitoIdentityUserPoolId)
//    
//    // initialize user pool client
//    AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: poolConfiguration, forKey: AWSCognitoUserPoolsSignInProviderKey)
//    
//    // fetch the user pool client we initialized in above step
//    let pool = AWSCognitoIdentityUserPool(forKey: AWSCognitoUserPoolsSignInProviderKey)
//    pool.delegate = self
//    Current.pool = pool
//    
//    // Initialize the Amazon Cognito credentials provider
//    let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast1,
//                                                            identityPoolId:"us-east-1:b022e33e-7f9a-404f-9874-2def6ce79c2e")
//    
//    let configuration = AWSServiceConfiguration(region:.USEast1, credentialsProvider:credentialsProvider)
//    
//    AWSServiceManager.default().defaultServiceConfiguration = configuration
//  }
//}
//
//extension AWSLoginManager: AWSCognitoIdentityInteractiveAuthenticationDelegate {
//  func startPasswordAuthentication() -> AWSCognitoIdentityPasswordAuthentication {
//    if (self.navigationController == nil) {
//      self.navigationController = self.storyboard?.instantiateViewController(withIdentifier: "signinController") as? UINavigationController
//    }
//    
//    if (self.signInViewController == nil) {
//      self.signInViewController = self.navigationController?.viewControllers[0] as? SignInViewController
//    }
//    
//    DispatchQueue.main.async {
//      self.navigationController!.popToRootViewController(animated: true)
//      if (!self.navigationController!.isViewLoaded
//        || self.navigationController!.view.window == nil) {
//        self.window?.rootViewController?.present(self.navigationController!,
//                                                 animated: true,
//                                                 completion: nil)
//      }
//      
//    }
//    return self.signInViewController!
//  }
//  
//  func startMultiFactorAuthentication() -> AWSCognitoIdentityMultiFactorAuthentication {
//    if (self.mfaViewController == nil) {
//      self.mfaViewController = MFAViewController()
//      self.mfaViewController?.modalPresentationStyle = .popover
//    }
//    DispatchQueue.main.async {
//      if (!self.mfaViewController!.isViewLoaded
//        || self.mfaViewController!.view.window == nil) {
//        //display mfa as popover on current view controller
//        let viewController = self.window?.rootViewController!
//        viewController?.present(self.mfaViewController!,
//                                animated: true,
//                                completion: nil)
//        
//        // configure popover vc
//        let presentationController = self.mfaViewController!.popoverPresentationController
//        presentationController?.permittedArrowDirections = UIPopoverArrowDirection.left
//        presentationController?.sourceView = viewController!.view
//        presentationController?.sourceRect = viewController!.view.bounds
//      }
//    }
//    return self.mfaViewController!
//  }
//  
//  func startRememberDevice() -> AWSCognitoIdentityRememberDevice {
//    return self
//  }
//}
