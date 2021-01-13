//
//  AlertButton.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 3.1.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import UIKit
import RxSwift


class AlertButton: UIButton {
    var disposeBag = DisposeBag()
    
    var type: AlertButtonType = .ok {
        didSet{
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateView()
    }
    
    private func updateView(){
        self.setTitle(type.buttonText, for: .normal)
        self.setTitleColor(Colors.white, for: .normal)
        self.backgroundColor = Colors.blueDefault
        self.layer.cornerRadius = CornerRadius.medium
        self.clipsToBounds = true
    }
    
    
   

}



