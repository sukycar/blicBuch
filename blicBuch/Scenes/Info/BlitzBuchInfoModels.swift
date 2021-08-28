//
//  BlitzBuchInfoModels.swift
//  blitzBuch
//
//  Created by Vladimir Sukanica on 17.7.21..
//  Copyright (c) 2021 Vladimir Sukanica. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

// MARK: - Enum

enum BlitzBuchInfo {
    
    // MARK: - Models

    struct TextModel {
        var titleText: String
        var separatorCustomText: String
        var firstSectionText: String
        var secondSectionTitle: String
        var secondSectionText: String
        var thirdSectionTitle: String
        var thirdSectionText: String
        var fourthSectionTitle: String
        var fourthSectionText: String
        
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
    
}
