//
//  StoresViewController.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-14.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit

class StoresViewController: ViffsViewController {

  @IBOutlet weak var offersCollectionView: UICollectionView!
  @IBOutlet weak var storesTableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    storesTableView.registerCell(type: StoreCell.self)
    offersCollectionView.registerCell(type: OfferCell.self)
    storesTableView.delegate = self
    storesTableView.dataSource = self
    offersCollectionView.delegate = self
    offersCollectionView.dataSource = self
  }
}

extension StoresViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Current.stores.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(type: StoreCell.self, forIndexPath: indexPath)
    let store = Current.stores[indexPath.row]
    cell.store = store
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    SceneCoordinator.shared.transition(to: Scene.store)
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension StoresViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return Current.offers.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(type: OfferCell.self, forIndexPath: indexPath)
    cell.offer = Current.offers[indexPath.row]
    return cell
  }
}
