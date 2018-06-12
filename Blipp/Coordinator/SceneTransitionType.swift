//
//  SceneTransitionType.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-10.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit

enum SceneTransitionType {
  case root(UIViewController)       // make view controller the root view controller.
  case push(UIViewController)       // push view controller to navigation stack.
  case present(UIViewController)    // present view controller.
  case alert(UIViewController)      // present alert.
}
