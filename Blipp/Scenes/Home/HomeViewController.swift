//
//  HomeViewController.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-14.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Overture

class HomeViewController: UIViewController, ViewModelBindable {
  typealias ReceiptDataSource = RxTableViewSectionedReloadDataSource<SectionModel<Int, Receipt>>
  
  let disposeBag = DisposeBag()
  // will be set by Coordinator
  var viewModel: HomeViewModelType!
  
  let dataSource = ReceiptDataSource(
    configureCell: { (_, tv, ip, receipt) in
      let cell = tv.dequeueReusableCell(type: ReceiptViewCell.self, forIndexPath: ip)
      cell.receipt = receipt
      return cell
    }
  )
  
  @IBOutlet weak var storesButton: UIButton!
  @IBOutlet weak var receiptsTableView: UITableView!
  @IBOutlet weak var showAllReceiptsButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    receiptsTableView.registerCell(type: ReceiptViewCell.self)
  }
  
  func bindViewModel() {
    bindUIToViewModel()
    bindViewModelToUI()
  }
  
  func bindUIToViewModel() {
    receiptsTableView.rx.modelSelected(Receipt.self)
      .bind(to: viewModel.inputs.receiptSelected)
      .disposed(by: disposeBag)
    
    let cardBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "card25x25"), style: .plain, target: nil, action: nil)
    navigationItem.setRightBarButton(cardBarButton, animated: false)
    
    cardBarButton.rx.tap
      .bind(to: viewModel.inputs.addCard)
      .disposed(by: disposeBag)
    
    storesButton.rx.tap
      .bind(to: viewModel.inputs.stores)
      .disposed(by: disposeBag)
    
    showAllReceiptsButton.rx.tap
      .bind(to: viewModel.inputs.showAllReceiptsButtonPressed)
      .disposed(by: disposeBag)
  }
  
  func bindViewModelToUI() {
    viewModel.outputs.receiptsContents
      .drive(receiptsTableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}
