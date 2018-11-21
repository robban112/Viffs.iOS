//
//  CardsViewController.swift
//  Viffs
//
//  Created by Oskar Ek on 2018-10-30.
//  Copyright © 2018 Viffs. All rights reserved.
//

import UIKit

class CardsViewController: ViffsViewController {
  
  @IBOutlet weak var cardsTableView: UITableView!
  
    @IBAction func AddCardButtonPushed(_ sender: Any) {
        SceneCoordinator.shared.transition(to: Scene.receiptCode)
    }
  
    @objc func reloadTable() {
      cardsTableView.reloadData()
    }
    
    override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: Notification.Name("CardsSet"), object: nil)
    cardsTableView.registerCell(type: CardCell.self)
    cardsTableView.delegate = self
    cardsTableView.dataSource = self
    // Do any additional setup after loading the view.
  }
}

extension CardsViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Current.cards.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(type: CardCell.self, forIndexPath: indexPath)
    let card = Current.cards[indexPath.row]
    cell.card = card
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let card = Current.cards[indexPath.row]
    SceneCoordinator.shared.transition(to: Scene.receipts(FilterParameters.init(cards: [card], filterByUserUpload: false)))
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
