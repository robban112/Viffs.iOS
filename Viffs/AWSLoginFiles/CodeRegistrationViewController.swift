//
//  CodeRegistrationViewController.swift
//  Viffs
//
//  Created by Robert Lorentz on 2018-10-10.
//  Copyright © 2018 Viffs. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider

class CodeRegistrationViewController: UIViewController {

  @IBOutlet var registerCode: UITextField!
  @IBOutlet weak var viewasd: UIView!
    var passwordAuthenticationCompletion: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>?
  @IBAction func continueAction(_ sender: Any) {
    let authDetails = AWSCognitoIdentityPasswordAuthenticationDetails(username: Current.username!, password: Current.password!)
    self.passwordAuthenticationCompletion?.set(result: authDetails)
  }
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CodeRegistrationViewController: AWSCognitoIdentityPasswordAuthentication {
  
  public func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput, passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
    self.passwordAuthenticationCompletion = passwordAuthenticationCompletionSource
    DispatchQueue.main.async {
      if (Current.username == nil) {
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
        //self.username.text = nil
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
}
