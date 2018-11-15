//
//  ViffsViewController.swift
//  Viffs
//
//  Created by Robert Lorentz on 2018-11-11.
//  Copyright © 2018 Viffs. All rights reserved.
//

import UIKit
import SideMenu

class ViffsViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    addSideMenuButton()
    setBackButton()
  }
  
  func setBackButton() {
    let backItem = UIBarButtonItem()
    backItem.title = ""
    if let topItem = self.navigationController?.navigationBar.topItem {
      topItem.backBarButtonItem = backItem
    }
  }
  
  func addSideMenuButton() {
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
    button.setImage(UIImage(named: "Tab-green-2"), for: .normal)
    
    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    self.view.addSubview(button)
    
    button.translatesAutoresizingMaskIntoConstraints = false
    let horizontalConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: -8)
    let verticalConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -57)
    let widthConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 64)
    let heightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 64)
    view.addConstraints([verticalConstraint, horizontalConstraint, widthConstraint, heightConstraint])
  }
  
  @objc func buttonAction(sender: UIButton!) {
    present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
  }
}
