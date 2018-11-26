//
//  ReceiptCodeViewController.swift
//  Viffs
//
//  Created by Robert Lorentz on 2018-11-14.
//  Copyright © 2018 Viffs. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader

class ReceiptCodeViewController: ViffsViewController, QRCodeReaderViewControllerDelegate {

  func readerDidCancel(_ reader: QRCodeReaderViewController) {
    dismiss(animated: true, completion: nil)
  }

    @IBOutlet var receiptCode: UITextField!

    @IBAction func continueAction(_ sender: Any) {
      _ = SceneCoordinator.shared.transition(to: Scene.registerCard)
      if receiptCode.text!.count != 0 {
        Current.receiptCode = receiptCode.text!
        //postReceiptCode(code: receiptCode.text!)
      }
    }

  lazy var readerVC: QRCodeReaderViewController = {
    let builder = QRCodeReaderViewControllerBuilder {
      $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
    }

    return QRCodeReaderViewController(builder: builder)
  }()

    @IBAction func scanQRAction(_ sender: Any) {
      // Retrieve the QRCode content
      // By using the delegate pattern
      readerVC.delegate = self

      // Presents the readerVC as modal form sheet
      readerVC.modalPresentationStyle = .formSheet
      present(readerVC, animated: true, completion: nil)
    }

  func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
    reader.stopScanning()
    receiptCode.text = result.value
    dismiss(animated: true, completion: nil)
  }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
