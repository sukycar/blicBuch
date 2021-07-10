//
//  InfoViewModelTest.swift
//  blitzBuchTests
//
//  Created by Vladimir Sukanica on 7.3.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import XCTest
@testable import blitzBuch

class InfoViewModelTest: XCTestCase {

    var viewModel : InfoViewViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let dataModel = InfoViewModel(titleText: InfoViewData.titleText, separatorCustomText: InfoViewData.separatorCustomText, firstSectionText: InfoViewData.firstSectionText, secondSectionTitle: InfoViewData.secondSectionTitle, secondSectionText: InfoViewData.secondSectionText, thirdSectionTitle: InfoViewData.thirdSectionTitle, thirdSectionText: InfoViewData.thirdSectionText, fourthSectionText: InfoViewData.fourthSectionText, fourthSectionTitle: InfoViewData.fourthSectionTitle)
        viewModel = InfoViewViewModel(model: dataModel)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testTextView() throws {
        let viewModelString = viewModel.getTextForTextView()
        XCTAssertNotEqual(viewModelString, NSAttributedString(string: ""))
    }

}
