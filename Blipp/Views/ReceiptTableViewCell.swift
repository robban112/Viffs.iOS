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
      self.receiptName?.text = receipt?.name
      self.receiptTotal?.text = receipt?.total
    }
  }
  
  @IBOutlet var receiptName: UILabel!
  @IBOutlet var receiptTotal: UILabel!
}