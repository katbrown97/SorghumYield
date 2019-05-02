//
//  LoginTests.swift
//  SorghumYieldUITests
//
//  Created by Jie Zheng on 5/1/19.
//  Copyright © 2019 Robert Sebek. All rights reserved.
//

class LoginTests : KIFTestCase {
    func testLoginWithExistingAccount(){
        tapButton(buttonName: "loginButton")
        var app = XCUIApplication()
        app.tables.textFields["Enter your email"].typeText("test@test.com")
    }
    
    func tapButton(buttonName : String){
        tester().tapView(withAccessibilityLabel: buttonName)
    }
    
    func setText(textField : String, text : String){
        tester().setText(text, intoViewWithAccessibilityLabel: textField)
    }
}
