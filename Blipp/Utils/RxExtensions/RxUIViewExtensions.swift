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

extension Reactive where Base: UITextField {
  /// Bindable sink for `rightView` property.
  var rightView: Binder<UIView?> {
    return Binder(self.base) { textField, view in
      textField.rightViewMode = .always
      textField.rightView = view
    }
  }
}
