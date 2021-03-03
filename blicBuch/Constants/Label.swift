//
//  Label.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12.12.20..
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit
typealias LabelTypeWithText = (type:LabelType, text:String?)

class Label: BaseLabel {
    override func setEdgeInsets() {
        topInset = CGFloat(0)
        bottomInset = CGFloat(0)
        leftInset = CGFloat(0)
        rightInset = CGFloat(0)
    }
    var type:LabelTypeWithText = (.none,"") {
        didSet{
            updateView()
        }
    }
    
    var customColor:UIColor?
    
    func updateView(){
        self.textColor = customColor ??  type.type.textColor
        self.font = UIFont(name: type.type.fontName.value, size: type.type.fontSize.preferedFontSize())
        if let bgColor = type.type.backgroundColor {
            self.backgroundColor = bgColor
        }
        if let textAlignment = type.type.textAlignment{
            self.textAlignment = textAlignment
        }
        
        if let edgeInsets = type.type.edgeInsets {
            topInset = edgeInsets.top
            bottomInset = edgeInsets.bottom
            leftInset = edgeInsets.left
            rightInset = edgeInsets.right
        }
        if let borderColor =  type.type.borderColor {
            self.layer.borderColor = borderColor
        }
        if let cornerRadius = type.type.cornerRadius {
            self.layer.cornerRadius = cornerRadius
        }
        if let borderSize =  type.type.borderSize {
            self.layer.borderWidth = borderSize
        }
        if let zPosition = type.type.zPosition {
            self.layer.zPosition = zPosition
        }
        
        
        self.text = type.text
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.updateView()
    }
}




