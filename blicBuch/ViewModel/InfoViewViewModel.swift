//
//  InfoViewViewModel.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 3.3.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation
import UIKit

class InfoViewViewModel {
    
    var model : InfoViewModel
    
    init(model : InfoViewModel){
        self.model = model
    }
    
    var titleText: String {
        return self.model.titleText
    }
    
    var separatorCustomText: String {
        return self.model.separatorCustomText
    }
    
    var firstSectionText: String {
        return self.model.firstSectionText
    }
    
    var secondSectionTitle: String {
        return self.model.secondSectionTitle
    }
    
    var secondSectionText: String {
        return self.model.secondSectionText
    }
    
    var thirdSectionTitle: String {
        return self.model.thirdSectionTitle
    }
    
    var thirdSectionText: String {
        return self.model.thirdSectionText
    }
    
    var fourthSectionTitle: String {
        return self.model.fourthSectionTitle
    }
    
    var fourthSectionText: String {
        return self.model.fourthSectionText
    }
    
    
    func getTextForTextView() -> NSAttributedString {
        let infoViewText = NSMutableAttributedString()
        let separatorLine = NSAttributedString(string: self.separatorCustomText, attributes: [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 15)!, NSAttributedString.Key.foregroundColor : Colors.Font.blackWhite()])
        let firstPart = NSAttributedString(string: self.firstSectionText, attributes: [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14)!, NSAttributedString.Key.foregroundColor : Colors.Font.blackWhite()])
        let partTwoTitle = NSAttributedString(string: self.secondSectionTitle, attributes: [NSAttributedString.Key.font : UIFont(name: "Roboto-Bold", size: 14)!, NSAttributedString.Key.foregroundColor : Colors.Font.blackWhite()])
        let partTwo = NSAttributedString(string: self.secondSectionText, attributes: [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14)!, NSAttributedString.Key.foregroundColor : Colors.Font.blackWhite()])
        let partThreeTitle = NSAttributedString(string: self.thirdSectionTitle, attributes: [NSAttributedString.Key.font : UIFont(name: "Roboto-Bold", size: 14)!, NSAttributedString.Key.foregroundColor : Colors.Font.blackWhite()])
        let partThree = NSAttributedString(string: self.thirdSectionText, attributes: [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14)!, NSAttributedString.Key.foregroundColor : Colors.Font.blackWhite()])
        let partFourTitle = NSAttributedString(string: self.fourthSectionTitle, attributes: [NSAttributedString.Key.font : UIFont(name: "Roboto-Bold", size: 14)!, NSAttributedString.Key.foregroundColor : Colors.Font.blackWhite()])
        let partFour = NSAttributedString(string: self.fourthSectionText, attributes: [NSAttributedString.Key.font : UIFont(name: "Roboto-Regular", size: 14)!, NSAttributedString.Key.foregroundColor : Colors.Font.blackWhite()])
        
        infoViewText.append(firstPart)
        infoViewText.append(separatorLine)
        infoViewText.append(partTwoTitle)
        infoViewText.append(partTwo)
        infoViewText.append(separatorLine)
        infoViewText.append(partThreeTitle)
        infoViewText.append(partThree)
        infoViewText.append(separatorLine)
        infoViewText.append(partFourTitle)
        infoViewText.append(partFour)
        
        return infoViewText
    }
    
}
