//
//  AllertMessage.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 17.7.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation

class AlertMessage: Error {
    
    // MARK: - Vars & Lets
    
    var title = ""
    var body = ""
    
    // MARK: - Init
    
    init(title: String, body: String) {
        self.title = title
        self.body = body
    }
    
}
