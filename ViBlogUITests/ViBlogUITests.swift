
//
//  ViBlogUITests.swift
//  ViBlogUITests
//
//  Created by Thang H Tong on 11/15/15.
//  Copyright © 2015 Thang. All rights reserved.
//

import XCTest

class ViBlogUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        let app = XCUIApplication()
        setLanguage(app)
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        // Failed to find matching element please file bug (bugreport.apple.com) and provide output from Console.app
        // Failed to find matching element please file bug (bugreport.apple.com) and provide output from Console.app
        
        // Failed to find matching element please file bug (bugreport.apple.com) and provide output from Console.app
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["new"].tap()
        tablesQuery.buttons["thumbupFilled"].tap()
        tablesQuery.buttons["thumbup"].tap()
        tablesQuery.buttons["PlayButton"].tap()
        tablesQuery.textFields["add your comment here..."].tap()
        tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(0).childrenMatchingType(.TextField).element.typeText("dddds")
        app.toolbars.buttons["Done"].tap()
        app.navigationBars["ViBlog.BlogsDetailTableView"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Friends"].tap()
        app.navigationBars["ViBlog.FriendsSearchTableView"].buttons["All Channels"].tap()
        tablesQuery.cells.containingType(.StaticText, identifier:"smut").buttons["Follow"].tap()
        tablesQuery.staticTexts["bemap"].tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery.buttons["Follow"].tap()
        collectionViewsQuery.buttons["is following"].tap()
        app.navigationBars["bemap"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0).tap()
        tabBarsQuery.buttons["Channels"].tap()
        app.navigationBars["thang"].buttons["buttonImageSettings"].tap()
        app.sheets["Select your option"].collectionViews.buttons["Edit Profile"].tap()
        
        
        
        // Failed to find matching element please file bug (bugreport.apple.com) and provide output from Console.app
        

        
    }
    
}
