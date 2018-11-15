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
      let str = NSString(format: "Received card info. \n Number: %@\n expiry: %02lu/%lu\n cvv: %@.", info.redactedCardNumber, info.expiryMonth, info.expiryYear, info.cvv)
      print(str)
    }
    paymentViewController.dismiss(animated: true, completion: nil)
  }
  

  
  @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet var month: UITextField!
    @IBOutlet var year: UITextField!
    @IBOutlet var cvc: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBAction func addCardButtonPushed(_ sender: Any) {
      self.navigationController?.popViewController(animated: false)
      self.navigationController?.popViewController(animated: false)
      print("cvc: \(String(describing: cvc.text)), month: \(String(describing: month.text)), year: \(year.text), cardNumber: \(String(describing: cardNumberTextField.text))")
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
