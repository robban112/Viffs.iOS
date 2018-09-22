//
//  MainViewController.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-09-19.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource,
UIGestureRecognizerDelegate {
  
  var addCard: UIBarButtonItem!
  var swipeCoordLoc: CGFloat!
  var beganAnimation: Bool = false
  var ignoreFollowingSwipes: Bool = false
  var startedAnimation: Bool = false
  let minHeightLatestReceipt: CGFloat = 320
  let maxHeightLatestReceipt: CGFloat = 400
  
  @IBOutlet var butikerLabel: UILabel!
  @IBOutlet var kvittoLabel: UILabel!
  @IBOutlet var latestReceiptSearchBar: UISearchBar!
  @IBOutlet var senasteKvittonLabel: UILabel!
  @IBOutlet var latestReceiptView: UIView!
  @IBOutlet var receiptButton: UIButton!
  @IBOutlet var storeButton: UIButton!
  @IBOutlet var receiptTableView: UITableView!
  
  @IBOutlet var latestReceiptViewHeightConstraint: NSLayoutConstraint!
  
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
    
    latestReceiptSearchBar.delegate = self
    latestReceiptViewHeightConstraint.constant = minHeightLatestReceipt
    
    let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
    panRecognizer.delegate = self
    latestReceiptView.addGestureRecognizer(panRecognizer)
    
    setObservers()
    addCard = UIBarButtonItem(image: UIImage(named: "addCardBlue")?.withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: #selector(cardBarButtonAction))
    navigationItem.setRightBarButton(addCard, animated: false)
  }
  
  func maximizeLatestReceiptView() {
    let screenSize: CGRect = UIScreen.main.bounds
    self.latestReceiptViewHeightConstraint.constant = screenSize.height - 100
    UIView.animate(withDuration: 0.35) { () -> Void in
      self.senasteKvittonLabel.isHidden = true
      self.addCard.isEnabled = false
      self.addCard.tintColor = UIColor.clear
      self.latestReceiptSearchBar.isHidden = false
      self.view.layoutIfNeeded()
    }
    startedAnimation = false
  }
  
  func minimizeLatestReceiptView() {
    self.latestReceiptViewHeightConstraint.constant = minHeightLatestReceipt
    UIView.animate(withDuration: 0.35) { () -> Void in
      self.senasteKvittonLabel.isHidden = false
      self.addCard.isEnabled = true
      self.addCard.tintColor = nil
      self.latestReceiptSearchBar.isHidden = true
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
}