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
  
  var cards: [Card]?
  var filteredReceipts: [Receipt] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    receiptTableView.delegate = self
    receiptTableView.dataSource = self
    receiptTableView.registerCell(type: ReceiptViewCell.self)
    filterReceiptByCards(cards: cards ?? Current.cards)
  }
  
  func filterReceiptByCards(cards: [Card]) {
    filteredReceipts = Current.receipts.filter({ (receipt) -> Bool in
      for card in cards {
        if card.pubID == receipt.cardPubID { return true }
      }
      return false
    })
  }
  
  @objc func reloadTable() {
    receiptTableView.reloadData()
    filterReceiptByCards(cards: cards ?? Current.cards)
  }
  
  func setObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: Notification.Name("StoreAdded"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: Notification.Name("ReceiptsSet"), object: nil)
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
