//
//  ReceiptViewController.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-05-15.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ReceiptViewController: UIViewController, ViewModelBindable {
  var viewModel: ReceiptViewModelType!
  let disposeBag = DisposeBag()
  
  let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<Int, Receipt>>(
    configureCell: { (_, tv, ip, receipt) in
      let cell = tv.dequeueReusableCell(type: ReceiptViewCell.self, forIndexPath: ip)
      cell.receipt = receipt
      return cell
    }
  )
  
  @IBOutlet var receiptTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    receiptTableView.registerCell(type: ReceiptViewCell.self)
  }
  
  func bindViewModel() {
    bindUIToViewModel()
    bindViewModelToUI()
  }
  
  func bindUIToViewModel() {
    receiptTableView.rx.modelSelected(Receipt.self)
      .bind(to: viewModel.inputs.receiptSelected)
      .disposed(by: disposeBag)
  }
  
  func bindViewModelToUI() {
    viewModel.outputs.receiptsContents
      .drive(receiptTableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}
