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

class ReceiptViewController: UIViewController {
  let viewModel: ReceiptViewModelType = ReceiptViewModel()
  let disposeBag = DisposeBag()
  
  @IBOutlet var receiptTableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bindUIToViewModel()
    bindViewModelToUI()
  }
  
  func bindUIToViewModel() {
    // Nothing to bind here yet
  }
  
  func bindViewModelToUI() {
    viewModel.outputs.receipts
      .drive(receiptTableView.rx.items(
        cellIdentifier: "ReceiptTableViewCell",
        cellType: ReceiptTableViewCell.self
      )) { _, receipt, cell in
        cell.receipt = receipt
      }
      .disposed(by: disposeBag)
  }
}

