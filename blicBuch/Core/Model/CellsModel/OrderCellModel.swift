//
//  OrderCellModel.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 6.3.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation

class OrderCellModel {
    
    let serviceText : String
    let priceText : String
    let orderButtonText: String
    
    init(serviceText : String, priceText : String, orderButtonText : String) {
        self.serviceText = serviceText
        self.priceText = priceText
        self.orderButtonText = orderButtonText
    }
}
