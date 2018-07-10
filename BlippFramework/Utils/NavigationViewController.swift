//
//  NavigationViewController.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-11.
//  Copyright © 2018 Blipp. All rights reserved.
//

import UIKit
import RxSwift

/// Implement this in the ViewModel if you need to do navigation
public protocol NavigationViewModelType {
  var navigate: Observable<Void> { get }
}
