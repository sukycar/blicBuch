//
//  InfoViewController.swift
//  blicBuch
//
//  Created by Vladimir Sukanica on 3/28/20.
//  Copyright © 2020 sukydeveloper. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
    
    
    @IBOutlet weak var titleHolderView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var infoViewViewModel = InfoViewViewModel(model: InfoViewModel(titleText: InfoViewData.titleText, separatorCustomText: InfoViewData.separatorCustomText, firstSectionText: InfoViewData.firstSectionText, secondSectionTitle: InfoViewData.secondSectionTitle, secondSectionText: InfoViewData.secondSectionText, thirdSectionTitle: InfoViewData.thirdSectionTitle, thirdSectionText: InfoViewData.thirdSectionText, fourthSectionText: InfoViewData.fourthSectionText, fourthSectionTitle: InfoViewData.fourthSectionTitle))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = infoViewViewModel.titleText
        titleHolderView.addBottomBorder(color: .gray, margins: 0, borderLineSize: 0.3)
        textView.attributedText = infoViewViewModel.getTextForTextView()
    }
}
