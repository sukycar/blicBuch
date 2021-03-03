//
//  InfoViewModel.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 3.3.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import Foundation

class InfoViewModel {
    let titleText: String
    let separatorCustomText: String
    let firstSectionText: String
    let secondSectionTitle: String
    let secondSectionText: String
    let thirdSectionTitle: String
    let thirdSectionText: String
    let fourthSectionTitle: String
    let fourthSectionText: String
    
    init(titleText : String, separatorCustomText : String, firstSectionText : String, secondSectionTitle : String, secondSectionText : String, thirdSectionTitle : String, thirdSectionText : String, fourthSectionText : String, fourthSectionTitle : String){
        self.titleText = titleText
        self.separatorCustomText = separatorCustomText
        self.firstSectionText = firstSectionText
        self.secondSectionTitle = secondSectionTitle
        self.secondSectionText = secondSectionText
        self.thirdSectionTitle = thirdSectionTitle
        self.thirdSectionText = thirdSectionText
        self.fourthSectionTitle = fourthSectionTitle
        self.fourthSectionText = fourthSectionText
    }
}
