//
//  CardCell.swift
//  Viffs
//
//  Created by Oskar Ek on 2018-10-30.
//  Copyright © 2018 Viffs. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {
  
  @IBOutlet weak var picture: UIImageView!
  @IBOutlet weak var name: UILabel!
  @IBOutlet weak var lastfour: UILabel!
  
  var card: Card? = nil {
    didSet {
      guard let card = card else { return }
      name.text = card.cardType
      picture.image = cardTypeToImage[card.cardType]
      let suffix = card.number.suffix(4)
      lastfour.text = String("****\(suffix)")
    }
  }
  
  override func prepareForReuse() {
    card = nil
  }
    
}
