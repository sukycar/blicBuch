//
//  Colors.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 5/24/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import Foundation
import UIKit

struct Colors {
    
    static let blueDefault = UIColor.init(named: "defaultBlue")!
    static let sideMenuBackgroundColor = UIColor.init(named: "sideMenuBackgroundColor")!
    static let defaultFontColor = UIColor.init(named: "defaultFontColor")!
    static let defaultBackgroundColor = UIColor.init(named: "defaultBackgroundColor")!
    static let orange = UIColor.orange
    static let white = UIColor.white
    static let black = UIColor.black
    
    struct Font {
        static let blue = UIColor.init(named: "defaultBlue")!
        static let gray = UIColor.gray
        static let black = UIColor.black
        static let white = UIColor.white
        static func blackWhite() -> UIColor {getColor(for: black, and: white)}
    }
    
    fileprivate static func getColor(for light:UIColor, and dark:UIColor ) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor.init { (trait) -> UIColor in return trait.userInterfaceStyle == .dark ? dark : light}
        } else {
            return light
        }
    }
    
    public static var tint: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    // Return the color for Dark Mode
                    return Colors.white
                } else {
                    // Return the color for Light Mode
                    return Colors.black
                }
            }
        } else {
            // Return a fallback color for iOS 12 and lower.
            return Colors.black
        }
    }()
}




