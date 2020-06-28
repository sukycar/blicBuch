//
//  FormatterHelpers.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 5/6/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import Foundation
class StaticHelpers {
    
    static let dateTimeFormatterWithDotsddMMYYYY:DateFormatter = {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
}
