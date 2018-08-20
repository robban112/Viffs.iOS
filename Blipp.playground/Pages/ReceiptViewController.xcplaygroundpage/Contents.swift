import UIKit
import PlaygroundSupport
import SnapKit
import Overture
@testable import BlippFramework

public final class ReceiptCell: UITableViewCell {
  private let titleDateStackView = UIStackView()
  
  private let storeTitleLabel = UILabel()
  private let dateLabel = UILabel()
  private let priceLabel = UILabel()
  private let shopImageView = UIImageView()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    titleDateStackView.axis = .vertical
    
    storeTitleLabel.font = UIFont(name: "ChalkboardSE-Light", size: 18)
    
    dateLabel.textColor = .darkGray
    dateLabel.font = UIFont(name: "ChalkboardSE-Light", size: 12)
    
    priceLabel.font = UIFont(name: "ChalkboardSE-Light", size: 18)
    
    shopImageView.contentMode = .scaleAspectFit
    shopImageView.image = #imageLiteral(resourceName: "ICA-logotyp.png")
    
    buildViewHierarchy()
    setUpConstraints()
  }
  
  private func buildViewHierarchy() {
    [dateLabel, storeTitleLabel]
      .forEach(titleDateStackView.addArrangedSubview(_:))
    
    [titleDateStackView, priceLabel, shopImageView]
      .forEach(contentView.addSubview(_:))
  }
  
  private func setUpConstraints() {
    titleDateStackView.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.left.equalTo(shopImageView.snp.right).offset(12)
    }
    
    priceLabel.snp.makeConstraints { make in
      make.right.equalToSuperview().inset(12)
      make.centerY.equalToSuperview()
    }
    
    shopImageView.snp.makeConstraints { make in
      make.left.equalToSuperview().inset(12)
      make.centerY.equalToSuperview()
      make.height.width.equalTo(55)
    }
  }
  
  func configure(with receipt: Receipt) {
    storeTitleLabel.text = receipt.name
    dateLabel.text = "24 november 2017"
    priceLabel.text = "\(receipt.total)\(receipt.currency)"
  }
  
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Shouldn't be used with storyboards")
  }
}

extension UIEdgeInsets {
  init(all inset: CGFloat) {
    self.init(top: inset, left: inset, bottom: inset, right: inset)
  }
}

let wrapInView: (UIEdgeInsets) -> (UIView) -> UIView = { insets in
  return { subView in
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(subView)
    subView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(insets)
    }
    return view
  }
}

final class ReceiptViewController2: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  private let receipts = [
    Receipt(currency: "SEK", name: "ICA", total: 1000, url: ""),
    Receipt(currency: "SEK", name: "Konsum", total: 40, url: "")
  ]
  
  private let searchStackView = UIStackView()
  
  private let searchBar = UISearchBar()
  private let sortButtonBackgroundView: UIView
  private let sortButton = UIButton()
  
  private let tableView = UITableView()
  
  init() {
    sortButtonBackgroundView = with(sortButton, wrapInView(.init(all: 18)))
    
    super.init(nibName: nil, bundle: nil)
    tableView.dataSource = self
    tableView.delegate = self
    
    sortButtonBackgroundView.backgroundColor = UIColor(rgb: 0x2C2C27)
    sortButton.normalBackgroundImage = #imageLiteral(resourceName: "sort2.png")
    
    searchBar.barStyle = .blackTranslucent
    
    buildViewHierarchy()
    setupConstraints()
  }
  
  private func buildViewHierarchy() {
//    sortButtonBackgroundView.addSubview(sortButton)
    
    [searchBar, sortButtonBackgroundView]
      .forEach(searchStackView.addArrangedSubview(_:))
    
    [searchStackView, tableView]
      .forEach(view.addSubview(_:))
  }
  
  private func setupConstraints() {
    sortButtonBackgroundView.snp.makeConstraints { make in
      make.width.height.equalTo(50)
    }
    
//    sortButton.snp.makeConstraints { make in
//      make.edges.equalToSuperview().inset(18)
//    }
    
    searchStackView.snp.makeConstraints { make in
      make.left.right.top.equalToSuperview()
    }
    
    tableView.snp.makeConstraints { make in
      make.left.right.bottom.equalToSuperview()
      make.top.equalTo(searchBar.snp.bottom)
    }
  }
  
  // uglyyyyy boilerplate
  required init?(coder aDecoder: NSCoder) {
    fatalError("Not supposed to be used with storyboards")
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = ReceiptCell()
    cell.configure(with: receipts[indexPath.row])
    cell.accessoryType = .disclosureIndicator
    return cell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return receipts.count
  }
}

PlaygroundPage.current.liveView = ReceiptViewController2()

