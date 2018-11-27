//
//  PictogramCell.swift
//  Viffs
//
//  Created by Oskar Ek on 2018-10-17.
//  Copyright © 2018 Viffs. All rights reserved.
//

import UIKit

class PictogramCell: UICollectionViewCell {

  @IBOutlet weak var pictogramImageView: UIImageView!

  var pictogramImage: UIImage? = nil {
    didSet {
      pictogramImageView.image = pictogramImage
    }
  }

  override func prepareForReuse() {
    pictogramImage = nil
  }
}
