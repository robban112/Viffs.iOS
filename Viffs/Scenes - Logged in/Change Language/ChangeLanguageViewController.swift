//
//  ChangeLanguageViewController.swift
//  Viffs
//
//  Created by Robert Lorentz on 2018-11-11.
//  Copyright © 2018 Viffs. All rights reserved.
//

import UIKit

class ChangeLanguageViewController: ViffsViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!

    private var content = ["Svenska", "English"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTableView()
    }

  func loadTableView() {
    tableView.dataSource = self
    tableView.delegate = self
    self.tableView.register(UINib(nibName: "MoreCell", bundle: nil), forCellReuseIdentifier: "MoreCell")
  }

  // MARK: - Table view data source

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return content.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "MoreCell", for: indexPath)
      as? MoreCell else { return UITableViewCell() }
    cell.label.text = content[indexPath.row]

    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    dismiss(animated: true, completion: nil)
    switch content[indexPath.row] {
    case "Svenska":
      return
    case "English":
      return
    default:
      return
    }
  }

}
