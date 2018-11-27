//
//  OfferCell.swift
//  Viffs
//
//  Created by Oskar Ek on 2018-10-30.
//  Copyright © 2018 Viffs. All rights reserved.
//

import UIKit

class OfferCell: UICollectionViewCell {

  @IBOutlet weak var picture: UIImageView!

  var offer: Offer? = nil {
    didSet {
      guard let offer = offer else { return }
      picture.image = offer.picture
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

}
