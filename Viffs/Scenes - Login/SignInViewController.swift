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
import AWSAuthCore

class SignInViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet weak var username: UITextField!
  @IBOutlet weak var password: UITextField!
  var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
  var usernameText: String?
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.password.delegate = self
    self.username.delegate = self
    self.password.text = Current.password
    //self.username.text = usernameText
    self.username.text = Current.username
    setNavBar()
    getSession()
  }
  
  func setNavBar() {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    self.navigationController?.navigationBar.shadowImage = UIImage()
    self.navigationController?.navigationBar.backItem?.title = ""

  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }
  
  func getSession(){
    Current.AWSUser?.getSession().continueOnSuccessWith { (getSessionTask) -> AnyObject? in
      DispatchQueue.main.async(execute: {
        let getSessionResult = getSessionTask.result
        
        //let idToken = getSessionResult?.idToken?.tokenString
        if let accessToken = getSessionResult?.accessToken?.tokenString {
          setReceipts(token: accessToken)
          Current.accessToken = accessToken
          print("Accesstoken: " + accessToken)
        }
      })
      return nil
    }
  }
  
  @IBAction func signInPressed(_ sender: AnyObject) {
    if (self.username.text != nil && self.password.text != nil) {
      
      let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: self.username.text!, password: self.password.text! )
      self.passwordAuthenticationCompletion?.set(result: authDetails)
      
      
    } else {
      let alertController = UIAlertController(title: "Missing information",
                                              message: "Please enter a valid user name and password",
                                              preferredStyle: .alert)
      let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
      alertController.addAction(retryAction)
    }
  }
}

extension SignInViewController: AWSCognitoIdentityPasswordAuthentication {
  
  public func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
    self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource
    DispatchQueue.main.async {
      if (self.usernameText == nil) {
        //self.usernameText = authenticationInput.lastKnownUsername
      }
    }
  }
  
  public func didCompleteStepWithError(_ error: Error?) {
    DispatchQueue.main.async {
      if let error = error as NSError? {
        let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                message: error.userInfo["message"] as? String,
                                                preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
        alertController.addAction(retryAction)
        
        self.present(alertController, animated: true, completion:  nil)
      } else {
        self.username.text = nil
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
}
