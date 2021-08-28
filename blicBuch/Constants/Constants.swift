//
//  Constants.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12.12.20..
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit

class Constants {
    static let userLogout = "UserLogout"
    static let userDefaultsToken = "UserDefaultsToken"
}

struct FontSize {
    static let label:CGFloat = 17
    static let field:CGFloat = 17
    static let html:CGFloat = 14
    static let emptyCollection:CGFloat = 15
    static let tabBar:CGFloat = 12
    static let navigationTitle:CGFloat  = 25
    static let attachmentName:CGFloat = 16
    static let segmentedText:CGFloat = 14
    static let placeholderText:CGFloat = 14
    static let filterSortText:CGFloat = 14
    static let discountFlag:CGFloat = 12
    static let datePicker:CGFloat = 14
    
    struct Header {
        static let title:CGFloat = 24
        static let subtitle:CGFloat = 14
    }
        
    struct Register {
        static let title:CGFloat = 12
        static let subtitle:CGFloat = 16
        static let info:CGFloat = 16
        static let labelInput:CGFloat = 16
        static let fieldInput:CGFloat = 16
        static let button:CGFloat = 18
        static let description:CGFloat = 14
    }
    
    struct Featured {
        static let slideShowFeatured:CGFloat = 12
        static let slideShowTitle:CGFloat = 20
        static let slideShowSubtitle:CGFloat = 16
    }
    
    struct Latest {
        static let priceTitle:CGFloat = 12
        static let title:CGFloat = 14
        static let location:CGFloat = 12
    }
    
    struct Toaster {
        static let toaster:CGFloat = 14
        static let toasterBig:CGFloat = 16
    }
    
    struct Cell {
        static let title:CGFloat = FontSize.label
        static let subtitle:CGFloat = FontSize.label
        static let info:CGFloat = FontSize.label
        static let price:CGFloat = FontSize.label
        static let type:CGFloat = FontSize.label
        static let newTitle:CGFloat = 16
        static let newSubtitle:CGFloat = 14
        static let largeTitle:CGFloat = 18
        static let bigTitle:CGFloat = 20
        static let promotionTitle:CGFloat = 16
        static let promotionRatingTitle:CGFloat = 53
        static let feedbackTitle:CGFloat = 16
    }
    
    struct Section {
        static let title:CGFloat = 14
        static let subtitle:CGFloat = 16
        static let new:CGFloat = 12
        static let viewAll:CGFloat = 14
        static let largeTitle:CGFloat = 18
    }
    
    struct Search {
        static let textField:CGFloat = 16
        static let sectionTitle:CGFloat = 14
        static let categoryTitle:CGFloat = 14
        static let hotSearch:CGFloat = 14
        static let searchButton:CGFloat = 12
        static let selectedTown:CGFloat = 16
        static let searchTitle:CGFloat = 12
    }
    struct Notification{
        static let cellText:CGFloat = 16
    }

}
extension CGFloat {
    func preferedFontSize() -> CGFloat {
        return self
    }
}


struct CornerRadius {
    static let none:CGFloat = 0
    static let lowest:CGFloat = 1
    static let low:CGFloat = 2
    static let mediumSmall:CGFloat = 3
    static let medium:CGFloat = 5
    static let high:CGFloat = 10
    static let large:CGFloat = 15
    static let larger:CGFloat = 16
    static let largest:CGFloat = 18
}
struct BorderWidth {
    static let none:CGFloat = 0
    static let lowest:CGFloat = 1
    static let low:CGFloat = 2
    static let medium:CGFloat = 3
    static let high:CGFloat = 4
}

let searchBtnChangeTag = 356
let searchLocationTag = 357
let badgeNumberTag = 358

extension UIFont {
    //TOASTER
    class func toasterLabel(text:String?) -> NSAttributedString {
        return customAttributedString(text: text, fontType: .regular, fontSize: FontSize.Toaster.toaster, alignment:.center, color: UIColor.white)
    }
}

extension UIFont {
    class func customAttributedString(text: String?,  fontType:FontName, fontSize:CGFloat, alignment:NSTextAlignment = .left, color: UIColor, underlineColor:UIColor? = nil) -> NSMutableAttributedString {
        
        let paragraph = NSMutableParagraphStyle();
        paragraph.alignment=alignment;
        let fontName = UIFont(name: fontType.value, size: fontSize.preferedFontSize())
        
        if let text = text {
            let wordRange = NSMakeRange(0, text.utf16.count)
            let attributedText = NSMutableAttributedString(string: text);
            attributedText.addAttribute(NSAttributedString.Key.font, value:fontName as Any, range:wordRange)
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value:color, range:wordRange)
            attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraph, range: wordRange)
            if let underlineColor = underlineColor {
                attributedText.addAttribute(NSAttributedString.Key.underlineColor, value: underlineColor, range: wordRange)
                attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: wordRange)
            }
            
            return attributedText
        }
        return NSMutableAttributedString(string: "");
    }
}

extension Optional where Wrapped == String {
    
}

