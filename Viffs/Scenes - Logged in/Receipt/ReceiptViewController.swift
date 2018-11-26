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
import Overture

class ReceiptViewController: ViffsViewController {

  let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<Int, Receipt>>(
    configureCell: { (_, tv, ip, receipt) in
      let cell = tv.dequeueReusableCell(type: ReceiptViewCell.self, forIndexPath: ip)
      cell.receipt = receipt
      return cell
    }
  )

  @IBOutlet var receiptTableView: UITableView!

  var cards: [Card]?
  var filteredReceipts: [Receipt] = []
  var filterParameters: FilterParameters?

  override func viewDidLoad() {
    super.viewDidLoad()
    receiptTableView.delegate = self
    receiptTableView.dataSource = self
    receiptTableView.registerCell(type: ReceiptViewCell.self)
    filterWithCurrentParameters()
    //filteredReceipts = filterReceiptByCards(cards: cards ?? Current.cards, receipts: Current.receipts)
  }

  func filterWithCurrentParameters() {
    filteredReceipts = filterByParameters(
      filterParameters: filterParameters ?? FilterParameters(cards: Current.cards, filterByUserUpload: false),
      filteredReceipts: Current.receipts
    )
  }

  func filterByParameters(filterParameters: FilterParameters, filteredReceipts: [Receipt]) -> [Receipt] {
    var filtered = filteredReceipts
    if filterParameters.cards.count != Current.cards.count {
      filtered = filterReceiptByCards(cards: filterParameters.cards, receipts: filteredReceipts)
    }
    if filterParameters.filterByUserUpload {
      filtered = filteredReceipts.filter { (receipt) -> Bool in
        return receipt.userUploaded
      }
    }
    return filtered
  }

  func filterReceiptByCards(cards: [Card], receipts: [Receipt]) -> [Receipt] {
    return receipts.filter { receipt in
      cards.contains(where: { $0.pubID == receipt.cardPubID })
    }
  }

  @objc func reloadTable() {
    receiptTableView.reloadData()
    filterWithCurrentParameters()
  }

  func setObservers() {
    NotificationCenter.default
      .addObserver(
        self,
        selector: #selector(reloadTable),
        name: Notification.Name("StoreAdded"),
        object: nil
      )
    NotificationCenter.default
      .addObserver(
        self,
        selector: #selector(reloadTable),
        name: Notification.Name("ReceiptsSet"),
        object: nil
      )
  }
}

extension ReceiptViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredReceipts.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(type: ReceiptViewCell.self, forIndexPath: indexPath)
    let receipt = filteredReceipts[indexPath.row]
    cell.receipt = receipt
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let receipt = filteredReceipts[indexPath.row]
    SceneCoordinator.shared.transition(to: Scene.receiptDetail(.init(receipt: receipt)))
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
