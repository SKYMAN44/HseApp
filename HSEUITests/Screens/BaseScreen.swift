//
//  BaseScreen.swift
//  HSEUITests
//
//  Created by Дмитрий Соколов on 11.06.2022.
//

import Foundation
import XCTest

class BaseScreen {
    public let app: XCUIApplication

    public init(_ app: XCUIApplication) {
        self.app = app
    }
}
