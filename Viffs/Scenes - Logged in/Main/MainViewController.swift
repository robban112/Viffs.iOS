//
//  MainViewController.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-09-19.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import Foundation
import SideMenu

class MainViewController: UIViewController, UITableViewDataSource,
UIGestureRecognizerDelegate {
  
  var addCard: UIBarButtonItem!
  var swipeCoordLoc: CGFloat!
  var beganAnimation: Bool = false
  var ignoreFollowingSwipes: Bool = false
  var startedAnimation: Bool = false
  let minHeightLatestReceipt: CGFloat = 230
  let maxHeightLatestReceipt: CGFloat = 400
  var maximized: Bool = false
  
    @IBOutlet var tableToSuperviewConstraint: NSLayoutConstraint!
    @IBOutlet var butikerLabel: UILabel!
  @IBOutlet var kvittoLabel: UILabel!
  @IBOutlet var latestReceiptSearchBar: UISearchBar!
  @IBOutlet var latestReceiptView: UIView!
  @IBOutlet var receiptButton: UIButton!
  @IBOutlet var storeButton: UIButton!
  @IBOutlet var receiptTableView: UITableView!
  
    @IBOutlet var arrowUpButton: UIButton!
    @IBOutlet var latestReceiptViewHeightConstraint: NSLayoutConstraint!
  
  @IBAction func receiptButtonPushed(_ sender: Any) {
    SceneCoordinator.shared.transition(to: Scene.mittViffs(.init()))
  }
  @IBAction func storeButtonPushed(_ sender: Any) {
    SceneCoordinator.shared.transition(to: Scene.stores)
  }
  @IBAction func arrowUpButtonPushed(_ sender: Any) {
    if (maximized) {
      minimizeLatestReceiptView()
    } else {
      maximizeLatestReceiptView()
    }
  }
  
  @IBAction func hamburgerButtonPushed(_ sender: Any) {
    present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
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
    
    latestReceiptSearchBar.delegate = self
    latestReceiptViewHeightConstraint.constant = minHeightLatestReceipt
    
    let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    panRecognizer.delegate = self
    latestReceiptView.addGestureRecognizer(panRecognizer)
    setObservers()
    setupSideMenu()
    addCard = addButton()
    navigationItem.setRightBarButton(addCard, animated: false)
  }
  
  func setupSideMenu() {
    // Define the menus
    let moreVC = MoreViewController.instantiateFromNib()
    moreVC.title = ""
    let navRight = UISideMenuNavigationController(rootViewController: moreVC)
    SideMenuManager.default.menuRightNavigationController = navRight
  }
  
  func addButton() -> UIBarButtonItem {
    let btn1 = UIButton(type: .custom)
    btn1.setImage(UIImage(named: "Kamera-Grön"), for: .normal)
    btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    btn1.addTarget(self, action: #selector(self.scanReceiptButtonPushed(_:)), for: .touchUpInside)
    return UIBarButtonItem(customView: btn1)
  }
  
  @objc func scanReceiptButtonPushed(_ sender: Any) {
//    present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
    SceneCoordinator.shared.transition(to: Scene.scanReceipt)
  }
  
  func maximizeLatestReceiptView() {
    let screenSize: CGRect = UIScreen.main.bounds
    maximized = true
    self.latestReceiptViewHeightConstraint.constant = screenSize.height - 100
    UIView.animate(withDuration: 0.35) { () -> Void in
      self.addCard.isEnabled = false
      self.addCard.tintColor = UIColor.clear
      self.latestReceiptSearchBar.isHidden = false
      self.tableToSuperviewConstraint.constant = 60
      self.arrowUpButton.setBackgroundImage(#imageLiteral(resourceName: "arrow-down-2"), for: .normal)
      self.view.layoutIfNeeded()
    }
    startedAnimation = false
  }
  
  func minimizeLatestReceiptView() {
    maximized = false
    self.latestReceiptViewHeightConstraint.constant = minHeightLatestReceipt
    UIView.animate(withDuration: 0.35) { () -> Void in
      self.addCard.isEnabled = true
      self.addCard.tintColor = nil
      self.latestReceiptSearchBar.isHidden = true
      self.tableToSuperviewConstraint.constant = 25
      self.arrowUpButton.setBackgroundImage(#imageLiteral(resourceName: "arrow-up-2"), for: .normal)
      self.view.layoutIfNeeded()
    }
    latestReceiptSearchBar.endEditing(true)
    setAlpha(alpha: 1)
    startedAnimation = false
  }
  
  func setAlphaOnButtonsAccordingToLatestReceiptHeight(height: CGFloat) {
    var transformedAlpha = (height - minHeightLatestReceipt) / (maxHeightLatestReceipt - minHeightLatestReceipt)
    //Flip
    transformedAlpha = -transformedAlpha + 1
    transformedAlpha = 0.3 + 0.7*transformedAlpha
    print("transformedAlpha: \(transformedAlpha)")
    setAlpha(alpha: transformedAlpha)
  }
  
  func setAlpha(alpha: CGFloat) {
    storeButton.alpha = alpha
    receiptButton.alpha = alpha
    butikerLabel.alpha = alpha
    kvittoLabel.alpha = alpha
  }
  
  func gestureChanged(translation: CGPoint) {
    let diff = swipeCoordLoc - translation.y
    if latestReceiptViewHeightConstraint.constant >= minHeightLatestReceipt {
      if latestReceiptViewHeightConstraint.constant + diff < minHeightLatestReceipt {
        latestReceiptViewHeightConstraint.constant = minHeightLatestReceipt
      } else {
        latestReceiptViewHeightConstraint.constant += diff
        swipeCoordLoc = translation.y
      }
      
      if latestReceiptViewHeightConstraint.constant > minHeightLatestReceipt && latestReceiptViewHeightConstraint.constant < maxHeightLatestReceipt {
        setAlphaOnButtonsAccordingToLatestReceiptHeight(height: latestReceiptViewHeightConstraint.constant)
      }
    }
  }
  
  func gestureEnded(verticalVelocity: CGFloat) {
    if latestReceiptViewHeightConstraint.constant > maxHeightLatestReceipt {
      if (verticalVelocity > 0) {
        minimizeLatestReceiptView()
      } else {
        maximizeLatestReceiptView()
      }
    } else {
      minimizeLatestReceiptView()
    }
  }
  
  @objc func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
    let translation = gestureRecognizer.translation(in: self.view)
    let verticalVelocity = gestureRecognizer.velocity(in: self.view).y
    
    if gestureRecognizer.state == .began {
      self.swipeCoordLoc = translation.y
      ignoreFollowingSwipes = false
    }
    if gestureRecognizer.state == .changed {
      gestureChanged(translation: translation)
    } else if gestureRecognizer.state == .ended {
      gestureEnded(verticalVelocity: verticalVelocity)
    }
  }
  
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
}

extension MainViewController: UISearchBarDelegate, UITableViewDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.endEditing(true)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let receipts = Current.user?.receipts {
      return receipts.count >= 2 ? 2 : receipts.count
    }
    return 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = ReceiptViewCell.instantiateFromNib()
    if let receipt = Current.user?.receipts?[indexPath.row] {
      cell.receipt = receipt
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let receipt = Current.user?.receipts?[indexPath.row] {
      SceneCoordinator.shared.transition(to: Scene.receiptDetail(.init(receipt: receipt)))
    }
  }
}
