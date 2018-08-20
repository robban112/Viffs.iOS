//
//  ReceiptCell.swift
//  BlippFramework
//
//  Created by Oskar Ek on 2018-08-20.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import Overture
import SnapKit

public final class ReceiptCell: UITableViewCell {
  private let titleDateStackView = UIStackView()
  private let storeTitleLabel = UILabel()
  private let dateLabel = UILabel()
  private let priceLabel = UILabel()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    titleDateStackView.axis = .vertical
    
    storeTitleLabel.font = UIFont(name: "ChalkboardSE-Light", size: 18)
    
    dateLabel.textColor = .darkGray
    dateLabel.font = UIFont(name: "ChalkboardSE-Light", size: 12)
    
    priceLabel.font = UIFont(name: "ChalkboardSE-Light", size: 18)
    
    self.backgroundColor = UIColor.white.withAlphaComponent(0.2)
    
    [dateLabel, storeTitleLabel]
      .forEach(titleDateStackView.addArrangedSubview(_:))
    
    [titleDateStackView, priceLabel]
      .forEach(contentView.addSubview(_:))
    
    setUpConstraints()
  }
  
  private func setUpConstraints() {
    titleDateStackView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.left.equalToSuperview().inset(12)
    }
    
    priceLabel.snp.makeConstraints { make in
      make.right.equalToSuperview().inset(12)
      make.centerY.equalToSuperview()
    }
  }
  
  func configure(with receipt: Receipt) {
    storeTitleLabel.text = receipt.name
    dateLabel.text = "24 november 2017"
    priceLabel.text = "\(receipt.total)\(receipt.currency)"
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Not used with storyboards")
  }
}
