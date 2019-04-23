//
//  LoginTests.swift
//  SorghumYieldTests
//
//  Created by Jie Zheng on 4/23/19.
//  Copyright © 2019 Robert Sebek. All rights reserved.
//

import KIF

class LoginTests : KIFTestCase {
    func testButton(){
        tester().tapView(withAccessibilityLabel: "getStartedButton")
    }
}
