//
//  NibCellUtils.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-10.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit

extension UITableView {
  func registerCell<T: UITableViewCell>(type: T.Type) {
    register(T.nib, forCellReuseIdentifier: String(describing: T.self))
  }
  
  func registerHeaderFooterView<T: UITableViewHeaderFooterView>(type: T.Type) {
    register(type.nib, forHeaderFooterViewReuseIdentifier: String(describing: T.self))
  }
  
  func dequeueReusableCell<T: UITableViewCell>(type: T.Type) -> T {
    guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self)) as? T
      else { fatalError("Couldn't find nib file for \(String(describing: T.self))") }
    return cell
  }
  
  func dequeueReusableCell<T: UITableViewCell>(type: T.Type, forIndexPath indexPath: IndexPath) -> T {
    guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T
      else { fatalError("Couldn't find nib file for \(String(describing: T.self))") }
    return cell
  }
  
  func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(type: T.Type) -> T {
    guard let headerFooterView = self.dequeueReusableHeaderFooterView(withIdentifier: String(describing: T.self)) as? T
      else { fatalError("Couldn't find nib file for \(String(describing: T.self))") }
    return headerFooterView
  }
}

extension UICollectionView {
  func registerCell<T: UICollectionViewCell>(type: T.Type) {
    register(type.nib, forCellWithReuseIdentifier: String(describing: T.self))
  }
  
  func dequeueReusableCell<T: UICollectionViewCell>(type: T.Type, forIndexPath indexPath: IndexPath) -> T {
    guard let cell = self.dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T else {
      fatalError("Couldn't find nib file for \(String(describing: T.self))")
    }
    return cell
  }
}
