//
//  MittViffsCell.swift
//  Viffs
//
//  Created by Oskar Ek on 2018-10-16.
//  Copyright © 2018 Viffs. All rights reserved.
//

import UIKit

class MittViffsCell: UICollectionViewCell {

  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var logo: UIImageView!

  var collection: ReceiptCollection? = nil {
    didSet {
      title.text = collection?.name
      logo.image = collection?.logo
    }
  }

  override func prepareForReuse() {
    collection = nil
  }

}
