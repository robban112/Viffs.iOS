//
//  CardRegisterViewController.swift
//  Viffs
//
//  Created by Robert Lorentz on 2018-10-09.
//  Copyright © 2018 Viffs. All rights reserved.
//

import UIKit

class CardRegisterViewController: UIViewController, CardIOPaymentViewControllerDelegate {
  
  func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
    print("User has canceled the scanner.")
    paymentViewController.dismiss(animated: true, completion: nil)
  }
  
  func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
    if let info = cardInfo {
      let str = NSString(format: "Received card info. \n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
      print(str)
    }
    paymentViewController.dismiss(animated: true, completion: nil)
  }
  

    
    @IBOutlet var cvc: UITextField!
    @IBOutlet var month: UITextField!
    @IBOutlet var year: UITextField!
    @IBOutlet var cardNumber: UITextField!
    @IBOutlet weak var viewasd: UIView!

    @IBAction func continueAction(_ sender: Any) {
        //push the card data here
      print("cvc: \(cvc.text), month: \(month.text), year: \(year.text), cardNumber: \(cardNumber.text)")
    }
    @IBAction func scanCardAction(_ sender: Any) {
      let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)!
      cardIOVC.hideCardIOLogo = true
      present(cardIOVC, animated: true, completion: nil)
      
    }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    print("cvc: \(cvc?.text), month: \(month?.text), year: \(year?.text), cardNumber: \(cardNumber?.text)")
  }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
