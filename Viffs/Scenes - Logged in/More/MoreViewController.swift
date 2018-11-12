//
//  MoreViewController.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-14.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SideMenu

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  let disposeBag = DisposeBag()
  @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableViewTopConstraint: NSLayoutConstraint!
  
  let rowHeight: CGFloat = 75
  var content = ["Hem","Mitt Viffs","Butiker","Kort","Hjälp","Inställningar", "Logga ut"]

  override func viewDidLoad() {
    loadTableView()
    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  func setTableViewToMiddle() {
    let screensize = UIScreen.main.bounds
    let height = screensize.height
    let tableViewHeight = rowHeight * CGFloat(content.count)
    tableViewTopConstraint.constant = (tableViewHeight-height)/2
  }
  
  func loadTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    self.tableView.register(UINib(nibName: "MoreCell", bundle: nil), forCellReuseIdentifier: "MoreCell");
  }
  
  // MARK: - Table view data source
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return rowHeight
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return content.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath)
      as! MoreCell
    cell.label.text = content[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    dismiss(animated: true, completion: nil)
    switch content[indexPath.row] {
    case "Hem":
      SceneCoordinator.shared.transitionToRoot()
      return
    case "Mitt Viffs":
      _ = SceneCoordinator.shared.transition(to: Scene.mittViffs(.init()))
      return
    case "Butiker":
      _ = SceneCoordinator.shared.transition(to: Scene.stores)
      return
    case "Kort":
      _ = SceneCoordinator.shared.transition(to: Scene.cards)
      return
    case "Hjälp":
      _ = SceneCoordinator.shared.transition(to: Scene.help)
      return
    case "Inställningar":
      _ = SceneCoordinator.shared.transition(to: Scene.settings)
      return
    case "Logga ut":
      Current.AWSUser?.signOut()
      SceneCoordinator.shared.transitionToLogin()
      return
    default:
      return
    }
  }

}
