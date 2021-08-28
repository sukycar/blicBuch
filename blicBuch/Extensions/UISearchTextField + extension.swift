//
//  UISearchTextField + extension.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 28.8.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import UIKit

extension UISearchTextField {
    var clearButton: UIButton? {
        return value(forKey: "_clearButton") as? UIButton
    }
}
