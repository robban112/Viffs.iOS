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
  var content = ["Kort","Lägg till kort" ,"Hjälp", "Byt språk" ,"Inställningar", "Logga ut"]

  override func viewDidLoad() {
    loadTableView()
    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  func loadTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    self.tableView.register(UINib(nibName: "MoreCell", bundle: nil), forCellReuseIdentifier: "MoreCell");
  }
  
  // MARK: - Table view data source
  
  func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
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
    case "Kort":
      return
    case "Lägg till kort":
      _ = SceneCoordinator.shared.transition(to: Scene.registerCard)
      return
    case "Hjälp":
      return
    case "Inställningar":
      return
    case "Byt språk":
      return
    case "Logga ut":
      Current.currentAWSUser?.signOut()
      SceneCoordinator.shared.transitionToLogin()
      return
    default:
      return
    }
  }

}
