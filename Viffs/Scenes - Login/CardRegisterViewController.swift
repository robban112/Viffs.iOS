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
      //     let str = NSString(format: "Received card info. \n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
      cardNumber.text = replaceCardNumber(cardNumber: info.cardNumber!)
    }
    paymentViewController.dismiss(animated: true, completion: nil)
  }
  
  func replaceCardNumber(cardNumber: String) -> String {
    if cardNumber.count > 12 {
      let start = cardNumber.index(cardNumber.startIndex, offsetBy: 5);
      let end = cardNumber.index(cardNumber.startIndex, offsetBy: 12);
      return cardNumber.replacingCharacters(in: start..<end, with: "*******")
    }
    return cardNumber
  }

    @IBOutlet var cardNumber: UITextField!
    @IBOutlet weak var viewasd: UIView!

    @IBAction func continueAction(_ sender: Any) {
        //push the card data here
      if let receiptCode = Current.receiptCode {
        if receiptCode.count == 6 && cardNumber.text!.count == 16 {
          //postReceiptCodeAndCard(code: receiptCode, cardNumber: replaceCardNumber(cardNumber: cardNumber.text!))
          Current.cardNumber = cardNumber.text!
          self.navigationController?.popToRootViewController(animated: true)
        }
      }

    }
    @IBAction func scanCardAction(_ sender: Any) {
      let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)!
      cardIOVC.hideCardIOLogo = true
      present(cardIOVC, animated: true, completion: nil)
      
    }
  
    @IBAction func submitCardLaterAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    self.navigationController?.popToRootViewController(animated: true)
  }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backItem?.title = ""
        // Do any additional setup after loading the view.
    }

}
