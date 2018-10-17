//
//  HamburgerButton.swift
//  Viffs
//
//  Created by Robert Lorentz on 2018-10-16.
//  Copyright © 2018 Viffs. All rights reserved.
//

import UIKit
import SideMenu

class HamburgerButton: UIButton {
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.setBackgroundImage(#imageLiteral(resourceName: "hamburger_menu"), for: .normal)
    self.addTarget(self, action: #selector(onPress), for: .touchUpInside)
  }
  
  func onPress() {
    present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
  }
}
