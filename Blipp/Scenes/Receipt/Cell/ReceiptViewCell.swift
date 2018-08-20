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
    }
  }
  
  override func prepareForReuse() {
    receipt = nil
  }
  
  @IBOutlet var receiptName: UILabel!
  @IBOutlet var receiptTotal: UILabel!
}
