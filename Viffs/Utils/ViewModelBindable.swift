//
//  ViewModelBindable.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-11.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import RxSwift

/// Implement if you want to be able to bind to a ViewModel
protocol ViewModelBindable {
  associatedtype ViewModelType

  var disposeBag: DisposeBag { get }
  var viewModel: ViewModelType! { get set }
  func bindViewModel()
}

extension ViewModelBindable where Self: UIViewController {
  mutating func bind(to viewModel: Self.ViewModelType) {
    self.viewModel = viewModel
    (self.viewModel as? NavigationViewModelType)?.navigate.subscribe().disposed(by: disposeBag)
    loadViewIfNeeded()
    bindViewModel()
  }
}

extension ViewModelBindable where Self: UITableViewCell {

  mutating func bind(to viewModel: Self.ViewModelType) {
    self.viewModel = viewModel
    bindViewModel()
  }

}

extension ViewModelBindable where Self: UICollectionViewCell {

  mutating func bind(to viewModel: Self.ViewModelType) {
    self.viewModel = viewModel
    bindViewModel()
  }

}
