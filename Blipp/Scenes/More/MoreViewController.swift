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

class MoreViewController: UIViewController {
  let disposeBag = DisposeBag()
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    tableView.registerCell(type: MoreCell.self)
    Observable.just(["Kort", "Hjälp", "Inställningar", "Logga ut"])
      .bind(to: tableView.rx.items(cellIdentifier: "MoreCell", cellType: MoreCell.self)) { (_, text, cell) in
        cell.label.text = text
      }
      .disposed(by: disposeBag)
  }
}
