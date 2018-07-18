import UIKit
import Overture
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import PlaygroundSupport
@testable import BlippFramework

public final class ReceiptCell: UITableViewCell {
  private let titleDateStackView = with(UIStackView(), mut(\.axis, .vertical))
  private let storeTitleLabel = with(UILabel(), mut(\.font, UIFont(name: "ChalkboardSE-Light", size: 18)))
  private let dateLabel = with(UILabel(), concat(
    mut(\.textColor, .darkGray),
    mut(\.font, UIFont(name: "ChalkboardSE-Light", size: 12))
  ))
  private let priceLabel = with(UILabel(), mut(\.font, UIFont(name: "ChalkboardSE-Light", size: 18)))
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
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

let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<Int, Receipt>>(
  configureCell: { (_, tv, ip, receipt) in
    let cell = tv.dequeueReusableCell(withIdentifier: "ReceiptCell", for: ip) as! ReceiptCell
    cell.configure(with: receipt)
    return cell
  }
)

func makeHomeButton(withImage image: UIImage) -> UIButton {
  return with(UIButton(), mut(\.normalBackgroundImage, image))
}

func makeButtonWithLabelStack() -> UIStackView {
  return with(UIStackView(), concat(
    mut(\.axis, .vertical),
    mut(\.alignment, .center),
    mut(\.spacing, 5)
  ))
}

// view controller
final public class HomeVC: UIViewController {
  
  let disposeBag = DisposeBag()
  
  // all the subviews
  
  private let background = with(UIImageView(image: #imageLiteral(resourceName: "hej.jpg")), backgroundStyle)
  
  private let rootStackView = with(UIStackView(), concat(
    stackBaseStyle,
    mut(\.spacing, 50)
  ))
  
  private let topStackView = with(UIStackView(), concat(
    mut(\.axis, .vertical),
    mut(\.alignment, .trailing)
  ))
  
  private let contentStackView = with(UIStackView(), concat(
    stackBaseStyle,
    mut(\.alignment, .center)
  ))
  
  private let buttonsStackView = with(UIStackView(), concat(
    mut(\.axis, .horizontal),
    mut(\.spacing, 50)
  ))
  
  private let tableViewWithTitleStackView = with(UIStackView(), concat(
    stackBaseStyle,
    mut(\.spacing, 28)
  ))
  
  private let tableViewTitleAndButtonView = UIView()
  
  private let receiptsStack = makeButtonWithLabelStack()
  private let shopsStack = makeButtonWithLabelStack()
  
  private let receiptsButton = makeHomeButton(withImage: #imageLiteral(resourceName: "Receiptbutton.png"))
  private let shopsButton = makeHomeButton(withImage: #imageLiteral(resourceName: "Shopbutton.png"))
  
  let addCardButton = with(UIButton(), concat(
    mut(\.normalBackgroundImage, #imageLiteral(resourceName: "add-card.png")),
    mut(\.imageView!.contentMode, .scaleAspectFit)
  ))
  
  let receiptsContents: Driver<[SectionModel<Int, Receipt>]> = Driver
    .just([ Receipt(currency: "SEK", name: "ICA", total: 1000, url: "")
          , Receipt(currency: "SEK", name: "Konsum", total: 550, url: "")
          , Receipt(currency: "SEK", name: "Pressbyrån", total: 35, url: "") ])
    .map { [SectionModel(model: 0, items: $0)] }
  
  let receiptsTableView = with(UITableView(), mut(\.rowHeight, 60))
  
  let tableViewTitle = with(UILabel(), concat(
    mut(\.font, UIFont(name: "ChalkboardSE-Regular", size: 18))
  ))
  let tableViewTitleButton = UIButton()
  
  public init() {
    super.init(nibName: nil, bundle: nil)

    buildViewHierarchy()

    setUpConstraints()
    
    bindToViewModel()
  }
  
  private func buildViewHierarchy() {
    [addCardButton]
      .forEach(topStackView.addArrangedSubview(_:))
    
    let receiptLabel = with(UILabel(), concat(
      mut(\.text, "Kvitton"),
      mut(\.font, UIFont(name: "ChalkboardSE-Light", size: 20))
    ))
    let shopsLabel = with(UILabel(), concat(
      mut(\.text, "Butiker"),
      mut(\.font, UIFont(name: "ChalkboardSE-Light", size: 20))
    ))
    
    [receiptsButton, receiptLabel]
      .forEach(receiptsStack.addArrangedSubview(_:))
    
    [shopsButton, shopsLabel]
      .forEach(shopsStack.addArrangedSubview(_:))
    
    [receiptsStack, shopsStack]
      .forEach(buttonsStackView.addArrangedSubview(_:))
    
    [buttonsStackView]
      .forEach(contentStackView.addArrangedSubview(_:))
    
    [topStackView, contentStackView]
      .forEach(rootStackView.addArrangedSubview(_:))

    tableViewTitle.text = "Dina tre senaste kvitton"

    tableViewTitleButton.setTitle("Visa alla", for: .normal)
    with(tableViewTitleButton, primaryButtonStyle)
    
    [tableViewTitle, tableViewTitleButton]
      .forEach(tableViewTitleAndButtonView.addSubview(_:))
    
    [tableViewTitleAndButtonView, receiptsTableView]
      .forEach(tableViewWithTitleStackView.addArrangedSubview(_:))
    
    [background, rootStackView, tableViewWithTitleStackView]
      .forEach(view.addSubview(_:))
  }
  
  private func setUpConstraints() {
    let margins = view.layoutMarginsGuide
    let safeMargins = view.safeAreaLayoutGuide

    background.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    rootStackView.snp.makeConstraints { make in
      make.left.right.top.equalTo(safeMargins).inset(8)
    }

    addCardButton.snp.makeConstraints { make in
      make.width.height.equalTo(50)
    }

    receiptsButton.snp.makeConstraints { make in
      make.width.height.equalTo(view.snp.width).dividedBy(3)
    }

    shopsButton.snp.makeConstraints { make in
      make.width.height.equalTo(view.snp.width).dividedBy(3)
    }
    
    tableViewWithTitleStackView.snp.makeConstraints { make in
      make.left.right.bottom.equalTo(safeMargins)
    }

    receiptsTableView.snp.makeConstraints { make in
      make.height.equalTo(180)
    }
    
    tableViewTitle.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.left.equalToSuperview().inset(8)
    }
    
    tableViewTitleButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.right.equalToSuperview().inset(8)
    }
  }
  
  func bindToViewModel() {
    receiptsTableView.register(ReceiptCell.self, forCellReuseIdentifier: "ReceiptCell")
    
    Driver.just(false)
      .drive(receiptsTableView.rx.isScrollEnabled)
      .disposed(by: disposeBag)
    
    receiptsContents
      .drive(receiptsTableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
  
  // ugly neccessary boilerplate
  public required init?(coder aDecoder: NSCoder) {
    fatalError("Not supposed to be used with storyboards")
  }
}

// Set the device type and orientation.
let (parent, _) = playgroundControllers(
  device: .phone4_7inch,
  orientation: .portrait,
  child: HomeVC()
)

//let cell = ReceiptCell.init(style: .default, reuseIdentifier: nil)
//cell.configure(with: Receipt(currency: "SEK", name: "ICA", total: 1000, url: ""))

PlaygroundPage.current.liveView = parent
