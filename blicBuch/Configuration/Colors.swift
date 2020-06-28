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
    
    static let blueDefault = UIColor(hexString: "#5cbff2")
    static let orange = UIColor.orange
    static let white = UIColor.white
    static let black = UIColor.black
    
    struct Font {
        static let blue = UIColor(hexString: "#5cbff2")
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
                    /// Return the color for Dark Mode
                    return Colors.white
                } else {
                    /// Return the color for Light Mode
                    return Colors.black
                }
            }
        } else {
            /// Return a fallback color for iOS 12 and lower.
            return Colors.black
        }
    }()
}



extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }// extension for using HEX code for colors
    
    
}
