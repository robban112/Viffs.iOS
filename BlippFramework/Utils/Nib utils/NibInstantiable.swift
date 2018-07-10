//
//  NibInstantiable.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-10.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation

import UIKit

fileprivate let bundle = Bundle(identifier: "com.Blipp.BlippFramework")

protocol NibInstantiable {
  static var nibIdentifier: String { get }
}

extension NibInstantiable {
  static var nib: UINib {
    return UINib.init(nibName: nibIdentifier, bundle: bundle)
  }
}

extension UIView: NibInstantiable {
  static var nibIdentifier: String {
    return String(describing: self)
  }
}

extension UIViewController: NibInstantiable {
  static var nibIdentifier: String {
    return String(describing: self)
  }
}

extension NibInstantiable where Self: UIView {
  static func instantiateFromNib() -> Self {
    guard let view = UINib(nibName: nibIdentifier, bundle: bundle)
      .instantiate(withOwner: nil, options: nil).first as? Self
      else { fatalError("Couldn't find nib file for \(String(describing: Self.self))") }
    return view
  }
}

extension NibInstantiable where Self: UIViewController {
  static func instantiateFromNib() -> Self {
    return .init(nibName: nibIdentifier, bundle: bundle)
  }
}

extension NibInstantiable where Self: UITableView {
  static func instantiateFromNib() -> Self {
    guard let tableView = UINib(nibName: nibIdentifier, bundle: bundle)
      .instantiate(withOwner: nil, options: nil).first as? Self
      else { fatalError("Couldn't find nib file for \(String(describing: Self.self))") }
    return tableView
  }
}

extension NibInstantiable where Self: UITableViewController {
  static func instantiateFromNib() -> Self {
    return .init(nibName: nibIdentifier, bundle: bundle)
  }
}
