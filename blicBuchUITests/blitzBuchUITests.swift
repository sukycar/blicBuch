//
//  blicBuchUITests.swift
//  blicBuchUITests
//
//  Created by Vladimir Sukanica on 1.3.21..
//  Copyright © 2021 sukydeveloper. All rights reserved.
//

import XCTest

class blitzBuchUITests: XCTestCase {


    var app : XCUIApplication!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        app = XCUIApplication()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLogin() throws {
        // UI tests must launch the application that they test.
        
        app.launch()
        print(app.debugDescription)
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Bibliothek"].tap()
        tabBar.buttons["VIP Member"].tap()
        tabBar.buttons["Informationen"].tap()
        tabBar.buttons["Home"].tap()
        app/*@START_MENU_TOKEN@*/.tables.staticTexts["Sonnen Tage"]/*[[".otherElements[\"homeTopViewACLabel\"].tables",".cells.matching(identifier: \"bookTableViewCell\").staticTexts[\"Sonnen Tage\"]",".staticTexts[\"Sonnen Tage\"]",".tables"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        print(app.textFields.debugDescription)
        let emailTextField = app/*@START_MENU_TOKEN@*/.textFields["eMailLoginField"]/*[[".otherElements[\"loginViewACLabel\"]",".textFields[\"E - mail *\"]",".textFields[\"eMailLoginField\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(emailTextField.exists)
        emailTextField.tap()
        emailTextField.typeText("sukycar@gmail.com")
        let passwordTextField = app/*@START_MENU_TOKEN@*/.textFields["passwordLoginField"]/*[[".otherElements[\"loginViewACLabel\"]",".textFields[\"Passwort *\"]",".textFields[\"passwordLoginField\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(passwordTextField.exists)
        passwordTextField.tap()
        passwordTextField.typeText("234")
        app/*@START_MENU_TOKEN@*/.staticTexts["Einloggen"]/*[[".otherElements[\"loginViewACLabel\"]",".buttons[\"Einloggen\"].staticTexts[\"Einloggen\"]",".buttons[\"einloggenButton\"].staticTexts[\"Einloggen\"]",".staticTexts[\"Einloggen\"]"],[[[-1,3],[-1,2],[-1,1],[-1,0,1]],[[-1,3],[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        
                

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testSideMenuReaction() throws {
                        
        app.launch()
        app/*@START_MENU_TOKEN@*/.buttons["sideMenuButton"]/*[[".otherElements[\"homeTopViewACLabel\"]",".buttons[\"img menu\"]",".buttons[\"sideMenuButton\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        print(app.debugDescription)
                                                
            
      
       
      
       
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
