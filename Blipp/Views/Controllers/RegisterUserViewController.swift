//
//  RegisterUserViewController.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-05-24.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegisterUserViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    var ref: DatabaseReference!
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
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
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    if let user = user {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
