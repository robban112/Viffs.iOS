//
//  CodeRegistrationViewController.swift
//  Viffs
//
//  Created by Robert Lorentz on 2018-10-10.
//  Copyright © 2018 Viffs. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import QRCodeReader

class CodeRegistrationViewController: UIViewController, QRCodeReaderViewControllerDelegate {

    @IBOutlet var registerCode: UITextField!
  @IBOutlet weak var viewasd: UIView!
  @IBAction func continueAction(_ sender: Any) {
    print("registercode: \(registerCode?.text ?? "")")
    if registerCode.text?.count != 0 {
      Current.receiptCode = registerCode.text

    }
    //self.navigationController?.popToRootViewController(animated: true)
  }

  @IBAction func submitCodeLaterAction(_ sender: Any) {
    if let username = Current.username, let password = Current.password {
      Current.loginManager.login(username: username, password: password)
    }
  }
    @IBAction func scanQRcodeButtonPushed(_ sender: Any) {
      // Retrieve the QRCode content
      // By using the delegate pattern
      readerVC.delegate = self

      // Or by using the closure pattern
      readerVC.completionBlock = { (result: QRCodeReaderResult?) in
        print(result ?? "No result")
      }

      // Presents the readerVC as modal form sheet
      readerVC.modalPresentationStyle = .formSheet
      present(readerVC, animated: true, completion: nil)
    }

  func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
    reader.stopScanning()
    registerCode.text = result.value
    dismiss(animated: true, completion: nil)
  }

  func readerDidCancel(_ reader: QRCodeReaderViewController) {
    dismiss(animated: true, completion: nil)
  }

  lazy var readerVC: QRCodeReaderViewController = {
    let builder = QRCodeReaderViewControllerBuilder {
      $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
    }

    return QRCodeReaderViewController(builder: builder)
  }()

  override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backItem?.title = ""

        // Do any additional setup after loading the view.
    }

}
