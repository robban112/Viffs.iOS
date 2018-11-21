//
//  ScanReceiptViewController.swift
//  Viffs
//
//  Created by Robert Lorentz on 2018-06-27.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import Vision
import WeScan

class ScanReceiptViewController: ViffsViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageScannerControllerDelegate {
  
  @IBOutlet var receiptImage: UIImageView!
  @IBOutlet var takePhotoButton: UIButton!
    
  @IBAction func sparaKvitto(_ sender: Any) {
    //receiptImage To base64 and post request
    let imageData = receiptImage.image!.jpegData(compressionQuality: 0.5)!
    let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
    let size = strBase64.utf8.count
    let s = strBase64.count
    uploadImage(base64: strBase64)
  }
  
  func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
    print(error)
  }
  
  func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
    receiptImage.image = results.scannedImage.convertToBlackAndWhite()
    scanner.dismiss(animated: true)
  }
  
  func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
    scanner.dismiss(animated: true)
    self.navigationController?.dismiss(animated: true, completion: nil)
  }
  
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let pickedImage = info[.originalImage] as? UIImage {
      receiptImage.contentMode = .scaleToFill
      receiptImage.image = pickedImage.convertToBlackAndWhite()
    }
    picker.dismiss(animated: true, completion: nil)
  }

  override func viewDidLoad() {
    let scannerVC = ImageScannerController()
    scannerVC.imageScannerDelegate = self
    self.present(scannerVC, animated: false)
    super.viewDidLoad()
  }
}
