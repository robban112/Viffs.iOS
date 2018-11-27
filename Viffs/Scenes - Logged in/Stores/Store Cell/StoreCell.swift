//
//  StoreCell.swift
//  Viffs
//
//  Created by Oskar Ek on 2018-10-17.
//  Copyright © 2018 Viffs. All rights reserved.
//

import UIKit

class StoreCell: UITableViewCell {

  @IBOutlet weak var storeImage: UIImageView!
  @IBOutlet weak var storeName: UILabel!

  var store: Store? = nil {
    didSet {
      guard let store = store else { return }
      storeName.text = store.name
      storeImage.image = storeToImage[store.name]
    }
  }

  override func prepareForReuse() {
    store = nil
  }

}
