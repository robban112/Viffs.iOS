//
//  StoresViewController.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-14.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import SideMenu

class StoresViewController: UIViewController {
    
    
    @IBOutlet var storeCollectionView: UICollectionView!
    
    @IBAction func hamburgerPushed(_ sender: Any) {
        present(SideMenuManager.default.menuRightNavigationController!, animated: true, completion: nil)
    }
    
}
