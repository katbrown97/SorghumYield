//
//  IntroView.swift
//  SorghumYieldUITests
//
//  Created by Jie Zheng on 4/15/19.
//  Copyright © 2019 Robert Sebek. All rights reserved.
//

import XCTest

extension XCUIApplication{
    var isDisplayingLogin: Bool {
        return otherElements["HomeView"].exists
    }
}
