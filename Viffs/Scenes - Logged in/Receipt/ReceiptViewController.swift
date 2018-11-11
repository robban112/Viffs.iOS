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

class ReceiptViewController: ViffsViewController {
  
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
    receiptTableView.delegate = self
    receiptTableView.dataSource = self
    receiptTableView.registerCell(type: ReceiptViewCell.self)
  }
  
  @objc func reloadTable() {
    receiptTableView.reloadData()
  }
  
  func setObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: Notification.Name("StoreAdded"), object: nil)
  }
}

extension ReceiptViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Current.receipts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(type: ReceiptViewCell.self, forIndexPath: indexPath)
    let receipt = Current.receipts[indexPath.row]
    cell.receipt = receipt
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let receipt = Current.receipts[indexPath.row]
    SceneCoordinator.shared.transition(to: Scene.receiptDetail(.init(receipt: receipt)))
  }
}
