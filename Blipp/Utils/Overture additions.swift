//
//  Overture additions.swift
//  Blipp
//
//  Created by Oskar Ek on 2018-06-17.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation
import Overture

public func update<A>(_ value: inout A, _ changes: ((A) -> A)...) {
  value = concat(changes)(value)
}

public func update<A>(_ value: inout A, _ changes: ((inout A) -> Void)...) {
  concat(changes)(&value)
}
