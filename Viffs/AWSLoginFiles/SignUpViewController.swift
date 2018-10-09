//
// Copyright 2014-2018 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Amazon Software License (the "License").
// You may not use this file except in compliance with the
// License. A copy of the License is located at
//
//     http://aws.amazon.com/asl/
//
// or in the "license" file accompanying this file. This file is
// distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, express or implied. See the License
// for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import AWSCognitoIdentityProvider

class SignUpViewController: UIViewController {
  
  var pool: AWSCognitoIdentityUserPool?
  var sentTo: String?
  
  @IBOutlet weak var username: UITextField!
  @IBOutlet weak var password: UITextField!
  
  @IBOutlet weak var email: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.pool = AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSignInProviderKey)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
  
  @IBAction func signUp(_ sender: AnyObject) {
    
    guard let userNameValue = self.username.text, !userNameValue.isEmpty,
      let passwordValue = self.password.text, !passwordValue.isEmpty else {
        let alertController = UIAlertController(title: "Missing Required Fields",
                                                message: "Username / Password are required for registration.",
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion:  nil)
        return
    }
    
    var attributes = [AWSCognitoIdentityUserAttributeType]()
    let family_name = AWSCognitoIdentityUserAttributeType()
    family_name?.name = "family_name"
    family_name?.value = "efternamn"
    attributes.append(family_name!)
    let given_name = AWSCognitoIdentityUserAttributeType()
    given_name?.name = "given_name"
    given_name?.value = "given name"
    attributes.append(given_name!)
    
    if let emailValue = self.email.text, !emailValue.isEmpty {
      let email = AWSCognitoIdentityUserAttributeType()
      email?.name = "email"
      email?.value = emailValue
      attributes.append(email!)
    }
    
    
    
    //sign up the user
    self.pool?.signUp(userNameValue, password: passwordValue, userAttributes: attributes, validationData: nil).continueWith {[weak self] (task) -> Any? in
      guard let strongSelf = self else { return nil }
      DispatchQueue.main.async(execute: {
        if let error = task.error as NSError? {
          let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                  message: error.userInfo["message"] as? String,
                                                  preferredStyle: .alert)
          let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
          alertController.addAction(retryAction)
          
          self?.present(alertController, animated: true, completion:  nil)
        } else if let result = task.result  {
            Current.username = self?.username.text
            Current.password = self?.password.text
        }
        
      })
      return nil
    }
  }
}
