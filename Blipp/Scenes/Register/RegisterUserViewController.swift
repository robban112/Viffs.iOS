//
//  RegisterUserViewController.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-05-24.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import RxSwift

class RegisterUserViewController: UIViewController, ViewModelBindable {
  
    let disposeBag = DisposeBag()
    var viewModel: RegisterUserViewModelType!
  

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var createAccountButton: UIButton!
    var ref: DatabaseReference!

    @IBAction func createAccountBtnPressed(_ sender: Any) {
        guard let email = emailTextField.text else {
            print("No email")
            return
        }
        
        guard let password = passwordTextField.text else {
            print("No password")
            return
        }
        if !email.isEmpty && !password.isEmpty {
            Auth.auth().createUser(withEmail: email, password: password) { (userData, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let user = userData?.user {
                        print("Successfully created user!")
                        self.ref.child("users").child(user.uid).setValue(["username": user.email])
                    }
                }
            }
        }
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func storageTest() {
        let storage = Storage.storage()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
    }
  
  func bindViewModel() {
    
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
