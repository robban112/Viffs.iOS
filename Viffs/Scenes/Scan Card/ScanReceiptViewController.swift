//
//  ScanReceiptViewController.swift
//  Blipp
//
//  Created by Kristofer Pitkäjärvi on 2018-06-27.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit

class ScanReceiptViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  @IBOutlet var receiptImage: UIImageView!
  @IBOutlet var takePhotoButton: UIButton!
  
  @IBAction func takePhoto(_ sender: Any) {
    print("Take photo button pushed!")
    if (!tookPhoto) {
      if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
      }
    } else {
      //TODO: add photo to database
    }
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
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      receiptImage.contentMode = .scaleToFill
      receiptImage.image = pickedImage
    }
    tookPhoto = true
    picker.dismiss(animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    tookPhoto = false
  }
}
