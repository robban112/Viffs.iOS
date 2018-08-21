//
//  Receipt.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-05-15.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit

class ReceiptViewCell: UITableViewCell {
  var receipt: Receipt? = nil {
    didSet {
      guard let receipt = receipt else { return }
      self.receiptName?.text = receipt.name
      let totalString = receipt.total.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", receipt.total) : String(receipt.total)
      self.receiptTotal?.text = totalString + receipt.currency
      if let picName = storeToLogo[receipt.name] {
        guard let image = UIImage(named: picName) else {
          print("Store exists in storeToLogo dictionary but the image doesn't exist!")
          return
        }
        self.storeLogo.image = image
      }
      //TODO: Receipt date
    }
  }
  
  override func prepareForReuse() {
    receipt = nil
  }
  
  @IBOutlet var receiptDate: UILabel!
  @IBOutlet var storeLogo: UIImageView!
  @IBOutlet var receiptName: UILabel!
  @IBOutlet var receiptTotal: UILabel!
}
