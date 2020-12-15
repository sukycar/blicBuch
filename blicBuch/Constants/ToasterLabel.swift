//
//  ToasterLabel.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 12.12.20..
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit

class ToasterLabel: BaseLabel {

    override func setEdgeInsets() {
        topInset = CGFloat(10)
        bottomInset = CGFloat(10)
        leftInset = CGFloat(10)
        rightInset = CGFloat(10)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.customizeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.customizeView()
    }
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.customizeView()
    }
    
    private func customizeView(){
        self.layer.cornerRadius = 0
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0
        self.clipsToBounds  = true
        self.backgroundColor = UIColor.blue
    }
}

struct ToasterMessage {
    
}

