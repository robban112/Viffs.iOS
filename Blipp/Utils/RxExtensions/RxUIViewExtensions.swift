//
//  RxUIViewExtensions.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-03.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
  var backgroundColor: Binder<UIColor?> {
    return Binder(self.base) { view, color in
      view.backgroundColor = color
    }
  }
}
