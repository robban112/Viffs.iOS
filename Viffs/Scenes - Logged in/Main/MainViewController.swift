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
import SkeletonView

class MainViewController: ViffsViewController, UITableViewDataSource,
UIGestureRecognizerDelegate {
  
  var addCard: UIBarButtonItem!
  var swipeCoordLoc: CGFloat!
  var beganAnimation: Bool = false
  var ignoreFollowingSwipes: Bool = false
  var startedAnimation: Bool = false
  let minHeightLatestReceipt: CGFloat = UIScreen.main.bounds.height*0.25
  let maxHeightLatestReceipt: CGFloat = UIScreen.main.bounds.height*0.5
  let curtainMaxPostion: CGFloat = UIScreen.main.bounds.height-100
  var maximized: Bool = false
  var receiptTableViewScrollIndex: CGFloat = 0
  var cameraButtonIsShown: Bool = false
  var placeHolderReceipts = [1,2,3]
  
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
  
  enum ScrollState {
    case maximizedAndAtTop      //Curtain at top and tableView at top
    case maximized              //Curtain at top and tableView not at top
    case minimized              //Curtain not at top
  }
  
  private var currentScrollState: ScrollState = .minimized {
    didSet {
      switch currentScrollState {
      case .maximizedAndAtTop:
        //Only scroll down
        hideCameraButton()
        receiptTableView.isScrollEnabled = true
        break
      case .maximized:
        hideCameraButton()
        receiptTableView.isScrollEnabled = true
        break
      case .minimized:
        showCameraButton()
        receiptTableView.isScrollEnabled = false
        break
      }
    }
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
    showCameraButton()
  }
  
  func setupSideMenu() {
    // Define the menus
    let moreVC = MoreViewController.instantiateFromNib()
    moreVC.title = ""
    let navRight = UISideMenuNavigationController(rootViewController: moreVC)
    SideMenuManager.default.menuRightNavigationController = navRight
  }
  
  func hideCameraButton() {
    if cameraButtonIsShown {
      cameraButtonIsShown = false
      navigationItem.setRightBarButton(nil, animated: true)
    }
  }
  
  func showCameraButton() {
    if !cameraButtonIsShown {
      cameraButtonIsShown = true
      addCard = addButton()
      navigationItem.setRightBarButton(addCard, animated: true)
    }
  }
  
  func addButton() -> UIBarButtonItem {
    let btn1 = UIButton(type: .custom)
    btn1.setImage(UIImage(named: "Kamera-green-small"), for: .normal)
    btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    btn1.addTarget(self, action: #selector(self.scanReceiptButtonPushed(_:)), for: .touchUpInside)
    return UIBarButtonItem(customView: btn1)
  }
  
  @objc func scanReceiptButtonPushed(_ sender: Any) {
//    present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
    SceneCoordinator.shared.transition(to: Scene.scanReceipt)
  }
  
  func maximizeLatestReceiptView() {
    maximized = true
    self.latestReceiptViewHeightConstraint.constant = curtainMaxPostion
    UIView.animate(withDuration: 0.35) { () -> Void in
      self.latestReceiptSearchBar.isHidden = false
      self.tableToSuperviewConstraint.constant = 60
      self.arrowUpButton.setBackgroundImage(#imageLiteral(resourceName: "arrow-down-2"), for: .normal)
      self.view.layoutIfNeeded()
    }
    currentScrollState = .maximizedAndAtTop
    startedAnimation = false
  }
  
  func minimizeLatestReceiptView() {
    maximized = false
    currentScrollState = .minimized
    self.latestReceiptViewHeightConstraint.constant = minHeightLatestReceipt
    UIView.animate(withDuration: 0.35) { () -> Void in
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
    setAlpha(alpha: transformedAlpha)
  }
  
  func setAlpha(alpha: CGFloat) {
    storeButton.alpha = alpha
    receiptButton.alpha = alpha
    butikerLabel.alpha = alpha
    kvittoLabel.alpha = alpha
  }
  
  func updateCurtainPosition(newLocation: CGFloat, diff: CGFloat) {
    if latestReceiptViewHeightConstraint.constant + diff >= curtainMaxPostion {
      latestReceiptViewHeightConstraint.constant = curtainMaxPostion
    } else if latestReceiptViewHeightConstraint.constant + diff <= minHeightLatestReceipt {
      latestReceiptViewHeightConstraint.constant = minHeightLatestReceipt
    } else {
      latestReceiptViewHeightConstraint.constant += diff
    }
  }
  
  func gestureChanged(translation: CGPoint) {
    let diff = swipeCoordLoc - translation.y
    let constraint = latestReceiptViewHeightConstraint.constant
    if constraint >= minHeightLatestReceipt && constraint <= curtainMaxPostion {
      switch currentScrollState {
      case .maximizedAndAtTop:
        if diff <= 0 {
          updateCurtainPosition(newLocation: translation.y, diff: diff)
          currentScrollState = .minimized
        } else if constraint == UIScreen.main.bounds.height-100 {

          currentScrollState = .maximized
        }
      case .maximized:
        break
      case .minimized:
        if diff > 0 { updateCurtainPosition(newLocation: translation.y, diff: diff) }
        else if constraint > minHeightLatestReceipt
        { updateCurtainPosition(newLocation: translation.y, diff: diff) }
      }
      if latestReceiptViewHeightConstraint.constant > minHeightLatestReceipt && latestReceiptViewHeightConstraint.constant < maxHeightLatestReceipt {
        setAlphaOnButtonsAccordingToLatestReceiptHeight(height: latestReceiptViewHeightConstraint.constant)
      }
    } 
    swipeCoordLoc = translation.y
  }
  
  func gestureEnded(verticalVelocity: CGFloat) {
    if latestReceiptViewHeightConstraint.constant > maxHeightLatestReceipt {
      if (verticalVelocity > 0 && currentScrollState != .maximized) {
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

extension MainViewController: SkeletonTableViewDataSource {
  func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  func numSections(in collectionSkeletonView: UITableView) -> Int {
    return 1
  }
  func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
    return "ReceiptViewCell"
  }
}

extension MainViewController: UISearchBarDelegate, UITableViewDelegate, UIScrollViewDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.endEditing(true)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if Current.isLoadingReceipts {
      return 2
    }
    return Current.receipts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = ReceiptViewCell.instantiateFromNib()
    if Current.isLoadingReceipts {
      cell.setIsLoading()
      return cell
    }
    cell.setNotLoading()
    if let receipt = Current.user?.receipts?[indexPath.row] {
      cell.receipt = receipt
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let receipt = Current.user?.receipts?[indexPath.row] {
      SceneCoordinator.shared.transition(to: Scene.receiptDetail(.init(receipt: receipt)))
    }
    tableView.deselectRow(at: indexPath, animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if receiptTableView.isScrollEnabled {
      let offset = scrollView.contentOffset.y
      if offset < 0 {
        currentScrollState = .maximizedAndAtTop
      }
      else if offset > 0 {
        currentScrollState = .maximized
      }
    }
  }
}
