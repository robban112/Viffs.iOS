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
  @IBAction func continueAction(_ sender: Any) {
    print("registercode: \(registerCode?.text)")
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  @IBAction func submitCodeLaterAction(_ sender: Any) {
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  
  override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
