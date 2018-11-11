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
  
  @IBAction func takePhoto(_ sender: Any) {
    print("Take photo button pushed!")
    
    if (!tookPhoto) {
      let scannerVC = ImageScannerController()
      scannerVC.imageScannerDelegate = self
      self.present(scannerVC, animated: true)
    } else {
      //receiptImage To base64 and post request
      let imageData = receiptImage.image!.pngData()!
      let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
      uploadImage(base64: strBase64)
    }
  }
  
  func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
    print(error)
  }
  
  func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
    receiptImage.image = results.scannedImage
    tookPhoto = true
    scanner.dismiss(animated: true)
  }
  
  func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
    scanner.dismiss(animated: true)
  }
  
  private var tookPhoto: Bool = false {
    didSet {
      if tookPhoto {
        takePhotoButton.backgroundColor = UIColor(displayP3Red: 127.0/255.0, green: 192.0/255.0, blue: 255.0/255.0, alpha: 1)
        takePhotoButton.titleLabel?.text = "Spara kvitto"
      } else {
        takePhotoButton.backgroundColor = UIColor(displayP3Red: 255.0/255.0, green: 204.0/255.0, blue: 185.0/255.0, alpha: 1)
        takePhotoButton.titleLabel?.text = "Scanna kvitto"
      }
    }
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let pickedImage = info[.originalImage] as? UIImage {
      receiptImage.contentMode = .scaleToFill
      receiptImage.image = pickedImage
    }
    tookPhoto = true
    picker.dismiss(animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tookPhoto = false
  }
}
