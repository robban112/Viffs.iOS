//
//  ReceiptInfoViewController.swift
//  Viffs
//
//  Created by Robert Lorentz on 2018-12-09.
//  Copyright © 2018 Viffs. All rights reserved.
//

import UIKit
import PromiseKit

class ReceiptInfoViewController: UIViewController {

  @IBOutlet var loadingImage: UIImageView!
  @IBOutlet var imageView: UIImageView!
  var receipt: Receipt?
  
  override func viewDidLoad() {
      super.viewDidLoad()
      setObservers()
      setIsLoading()
      setBackButton()
      setImage()
  }
  
  func setImage() {
    if let receipt = receipt {
      _ = getImage(for: receipt).done { image in
        self.imageView.image = image
        Current.isLoadingReceiptDetail = false
      }
    }
  }
  
  func setBackButton() {
    let backItem = UIBarButtonItem()
    backItem.title = ""
    if let topItem = self.navigationController?.navigationBar.topItem {
      topItem.backBarButtonItem = backItem
    }
  }
  
  func setIsLoading() {
    //imageView.showAnimatedGradientSkeleton()
    let gif = UIImage.gif(name: "Loading-Spinner")
    loadingImage.image = gif
  }
  
  @objc func setIsNotLoading() {
    loadingImage.image = nil
  }
  
  func setObservers() {
    NotificationCenter
      .default
      .addObserver(
        self,
        selector: #selector(setIsNotLoading),
        name: Notification.Name("ReceiptImageSet"),
        object: nil
    )
  }
}
