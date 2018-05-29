//
//  Receipt.swift
//  Blipp
//
//  Created by Robert Lorentz on 2018-05-15.
//  Copyright © 2018 Blipp. All rights reserved.
//

import Foundation

class Receipt {
    var receiptName: String!
    var receiptTotal: String!
    
    init(name: String, total: String) {
        self.receiptName = name
        self.receiptTotal = total
    }
}
