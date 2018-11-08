//
//  CardsViewController.swift
//  Viffs
//
//  Created by Oskar Ek on 2018-10-30.
//  Copyright © 2018 Viffs. All rights reserved.
//

import UIKit
import SideMenu

class CardsViewController: UIViewController {
  
  @IBOutlet weak var cardsTableView: UITableView!
  
  @IBAction func hamburgerButtonPushed(_ sender: Any) {
    present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
    SceneCoordinator.shared.transition(to: Scene.receipts())
  }
}