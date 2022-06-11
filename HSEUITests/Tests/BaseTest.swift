//
//  BaseTest.swift
//  HSEUITests
//
//  Created by Дмитрий Соколов on 11.06.2022.
//

import XCTest
import Foundation

class BaseTest: XCTestCase {
    lazy var app = XCUIApplication()

    open override func setUp() {
        app.launchArguments = ["enable-testing"]
        app.launch()
        continueAfterFailure = false
    }

    open override func tearDown() {
        app.terminate()
    }
}
