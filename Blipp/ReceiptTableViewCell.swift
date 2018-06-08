//
//  Receipt.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-05-15.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit

class ReceiptTableViewCell: UITableViewCell {
  var receipt: Receipt? = nil {
    didSet {
      self.receiptName?.text = receipt?.receiptName
      self.receiptTotal?.text = receipt?.receiptTotal
    }
  }
  
  @IBOutlet var receiptName: UILabel!
  @IBOutlet var receiptTotal: UILabel!
}
