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
      receiptName.text = loadReceiptName(receipt: receipt)
      let totalString = receipt.total.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", receipt.total) : String(receipt.total)
      self.receiptTotal?.text = totalString + receipt.currency
      storeLogo.image = loadStoreImage(receiptName: receiptName.text!)
      receiptDate.text = receipt.date
    }
  }
  
  override func prepareForReuse() {
    receipt = nil
  }
  
  func loadStoreImage(receiptName: String) -> UIImage? {
    if let picName = storeToLogo[receiptName] {
      if let image = UIImage(named: picName) {
        return image
      }
    }
    return nil
  }
  
  func loadReceiptName(receipt: Receipt) -> String {
    print(Current.storeDict)
    if let store = Current.storeDict[receipt.storePubID] {
      return store.name
    }
    return receipt.name
  }
  
  @IBOutlet var receiptDate: UILabel!
  @IBOutlet var storeLogo: UIImageView!
  @IBOutlet var receiptName: UILabel!
  @IBOutlet var receiptTotal: UILabel!
}
