//
//  UIView + globalFrame.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 25.2.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var globalFrame: CGRect? {
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        return self.superview?.convert(self.frame, to: rootView)
        
    }
}
