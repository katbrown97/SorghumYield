//
//  SorghumYieldUITests.swift
//  SorghumYieldUITests
//
//  Created by Jie Zheng on 4/15/19.
//  Copyright © 2019 Robert Sebek. All rights reserved.
//

import XCTest

class SorghumYieldUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        app.launchArguments.append("--UITeting")
    }
    
    
    
    func testLoginAndSubmitReport(){
        
        let app = XCUIApplication()
        var element = app/*@START_MENU_TOKEN@*/.buttons["loginButton"]/*[[".buttons[\"Login\"]",".buttons[\"loginButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        waitAndAssert(element: element)
        element.tap()
        
        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        element = tablesQuery.textFields["Enter your email"]
        waitAndAssert(element: element)
        element.tap()
        setText(text: "test123@test.com", element: element)
        
        app.navigationBars["Enter your email"]/*@START_MENU_TOKEN@*/.buttons["NextButtonAccessibilityID"]/*[[".buttons[\"Next\"]",".buttons[\"NextButtonAccessibilityID\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        element = tablesQuery/*@START_MENU_TOKEN@*/.secureTextFields["Enter your password"]/*[[".cells.secureTextFields[\"Enter your password\"]",".secureTextFields[\"Enter your password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        element.tap()
        setText(text: "12345678", element: element)
    
        app.navigationBars["Sign in"].buttons["Sign in"].tap()
        
        element = app.buttons["getStartedButton"]
        waitAndAssert(element: element)
        element.tap()
        
        element = app.scrollViews.otherElements.textFields["For statistics"]
        waitAndAssert(element: element)
        element.tap()
        setText(text: "testField", element: element)
        
        element = app.scrollViews.otherElements.textFields["How big is your farm"]
        element.tap()
        setText(text: "123", element: element)
        
        element = app.toolbars["Toolbar"].buttons["Done"]
        waitAndAssert(element: element)
        element.tap()
    
        app.buttons["Next"].tap()
        element = app.navigationBars["PageRootView"].buttons["Skip"]
        XCTAssertTrue(element.waitForExistence(timeout: 3))
        element.tap()
        
        app.buttons["Gallery"].tap()
        
        
    }

    func setText(text: String, element: XCUIElement){
        element.typeText(text)
    }
    
    func waitAndAssert(element: XCUIElement){
        XCTAssertTrue(element.waitForExistence(timeout: 10))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
