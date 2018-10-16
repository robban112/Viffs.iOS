//
//  DeveloperAuthenticatedIdentityProvider.swift
//  Viffs
//
//  Created by Robert Lorentz on 2018-10-15.
//  Copyright © 2018 Viffs. All rights reserved.
//

import Foundation
import AWSCore

class DeveloperAuthenticatedIdentityProvider: AWSCognitoCredentialsProviderHelper {
  
//  override func logins() -> AWSTask<NSDictionary> {
//    //Write code to call your backend:
//    //pass username/password to backend or some sort of token to authenticate user, if successful,
//    //from backend call getOpenIdTokenForDeveloperIdentity with logins map containing "your.provider.name":"enduser.username"
//    //return the identity id and token to client
//    //You can use AWSTaskCompletionSource to do this asynchronously
//
////    // Set the identity id and return the token
////    self.identityId = resultFromAbove.identityId
//    return AWSTask(result: resultFromAbove.token)
//  }
}
