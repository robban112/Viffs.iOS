//
//  CardRegisterViewController.swift
//  Viffs
//
//  Created by Robert Lorentz on 2018-10-09.
//  Copyright © 2018 Viffs. All rights reserved.
//

import UIKit

class CardRegisterViewController: UIViewController {

    
    @IBOutlet var cvc: UITextField!
    @IBOutlet var month: UITextField!
    @IBOutlet var year: UITextField!
    @IBOutlet var cardNumber: UITextField!
    @IBOutlet weak var viewasd: UIView!

    @IBAction func continueAction(_ sender: Any) {
        //push the card data here
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
