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

class ReceiptViewController: UIViewController {
  var viewModel: ReceiptViewModelType!
  let disposeBag = DisposeBag()
  
  let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<Int, Receipt>>(
    configureCell: { (_, tv, ip, receipt: Receipt) in
      let cell = tv.dequeueReusableCell(withIdentifier: "ReceiptTableViewCell") as! ReceiptTableViewCell
      cell.receipt = receipt
      return cell
    }
  )
  
  @IBOutlet var receiptTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
