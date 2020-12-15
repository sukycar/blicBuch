//
//  BaseLabel.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12.12.20..
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit

class BaseLabel: UILabel {
    var topInset = CGFloat(0)
    var bottomInset = CGFloat(0)
    var leftInset = CGFloat(0)
    var rightInset = CGFloat(0)
    
    func setEdgeInsets() {
        //set insets
    }
    
    override func drawText(in rect: CGRect) {
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override public var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setEdgeInsets()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setEdgeInsets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setEdgeInsets()
    }
}
