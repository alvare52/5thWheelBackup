//
//  WheelRVUITests.swift
//  WheelRVUITests
//
//  Created by Jorge Alvarez on 3/2/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import XCTest
@testable import _thWheelRV

// The warnings in here are hugged, and so is the @testable import 5thWheelRV
class WheelRVUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let app = XCUIApplication()
        app.launch()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state -
        // such as interface orientation - required for your tests before they run.
        //The setUp method is a good place to do this.
    }

    func testChangeLoginType() {

        let app = XCUIApplication()
        //let loginVC = LoginViewController()
        app/*@START_MENU_TOKEN@*/.buttons["Log In"]/*[[".segmentedControls.buttons[\"Log In\"]",".buttons[\"Log In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        //app/*@START_MENU_TOKEN@*/.buttons["Sign Up"]/*[[".segmentedControls.buttons[\"Sign Up\"]",".buttons[\"Sign Up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        //XCTAssertEquals(loginVC.loginType, LoginType.logIn)
        //XCTAssertTrue(loginVC.loginType == .logIn)
    }

    func testChangeUserType() {

        let app = XCUIApplication()
        //let loginVC = LoginViewController()
        app.buttons["RV Owner"].tap()
        //app/*@START_MENU_TOKEN@*/.buttons["Sign Up"]/*[[".segmentedControls.buttons[\"Sign Up\"]",".buttons[\"Sign Up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        //XCTAssertEquals(loginVC.loginType, LoginType.logIn)
        //XCTAssertTrue(loginVC.loginType == .logIn)
    }
}
