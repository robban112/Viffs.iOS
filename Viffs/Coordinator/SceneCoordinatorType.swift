//
//  SceneCoordinatorType.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-10.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import RxSwift

protocol SceneCoordinatorType {
  init(window: UIWindow, storyboard: UIStoryboard)
  func transitionToLogin()
  @discardableResult func transition(to scene: TargetScene) -> Observable<Void>
  @discardableResult func pop(animated: Bool) -> Observable<Void>
}
