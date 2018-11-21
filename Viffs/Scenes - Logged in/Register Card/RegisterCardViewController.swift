//
//  RegisterCardViewController.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-14.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterCardViewController: ViffsViewController, CardIOPaymentViewControllerDelegate {
  
  func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
    print("User has canceled the scanner.")
    paymentViewController.dismiss(animated: true, completion: nil)
  }
  
  func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
    if let info = cardInfo {
 //     let str = NSString(format: "Received card info. \n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
      cardNumberTextField.text = replaceCardNumber(cardNumber: info.cardNumber!)
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

  
  @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBAction func addCardButtonPushed(_ sender: Any) {
      if let receiptCode = Current.receiptCode, let cardNumber = cardNumberTextField.text {
        if receiptCode.count == 6 && cardNumber.count == 16 {
          postReceiptCodeAndCard(code: receiptCode, cardNumber: replaceCardNumber(cardNumber: cardNumber))
          self.navigationController?.popViewController(animated: false)
          self.navigationController?.popViewController(animated: false)
        }
      }
    }
  
  @IBAction func scanCardButtonPushed(_ sender: Any) {
    let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)!
    
    cardIOVC.hideCardIOLogo = true
    present(cardIOVC, animated: true, completion: nil)

  }
    
  
  override func viewDidLoad() {
    super.viewDidLoad()
    CardIOUtilities.preload()
  }
}
