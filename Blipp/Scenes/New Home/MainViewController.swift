//
//  MainViewController.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-09-19.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let receipts = Current.currentUser?.receipts {
      return receipts.count >= 2 ? 2 : receipts.count
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = ReceiptViewCell.instantiateFromNib()
    if let receipt = Current.currentUser?.receipts?[indexPath.row] {
      cell.receipt = receipt
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let receipt = Current.currentUser?.receipts?[indexPath.row] {
      SceneCoordinator.shared.transition(to: Scene.receiptDetail(.init(receipt: receipt)))
    }
  }
  
  
    @IBOutlet var receiptButton: UIButton!
    @IBOutlet var storeButton: UIButton!
    @IBOutlet var receiptTableView: UITableView!
    
    @IBAction func receiptButtonPushed(_ sender: Any) {
      SceneCoordinator.shared.transition(to: Scene.receipts(.init()))
    }
    @IBAction func storeButtonPushed(_ sender: Any) {
      SceneCoordinator.shared.transition(to: Scene.stores)
    }
  
  @objc func cardBarButtonAction(sender:UIButton!) {
      SceneCoordinator.shared.transition(to: Scene.registerCard(.init()))
    }
  
  @objc func reloadTable() {
    receiptTableView.reloadData()
  }
  
  func setObservers() {
    NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: Notification.Name("ReceiptsSet"), object: nil)
    
    NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: Notification.Name("StoreAdded"), object: nil)
  }
    
    override func viewDidLoad() {
      super.viewDidLoad()
      receiptTableView.delegate = self
      receiptTableView.dataSource = self
      setObservers()
      let cardBarButton = UIBarButtonItem(image: UIImage(named: "addCardBlue")?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: #selector(cardBarButtonAction))
      navigationItem.setRightBarButton(cardBarButton, animated: false)
    }
}
