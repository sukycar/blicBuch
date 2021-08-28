//
//  CustomProgressHUD.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 17.7.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import MBProgressHUD

class CustomProgressHUD: MBProgressHUD {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    override init(view: UIView) {
        super.init(view: view)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    // MARK: - Private methods
    
    private func setup() {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        contentColor = Colors.orange
        bezelView.color = .clear
        bezelView.style = .solidColor
    }
}
