//
//  LoginTests.swift
//  HSEUITests
//
//  Created by Дмитрий Соколов on 11.06.2022.
//

import XCTest

final class CoffeeScreenTest: BaseTest {
    lazy var loginScreen = LoginScreen(app)

    func testBasicFlow() {
        loginScreen
            .enterEmail("gelik228@gmail.com")
            .touchTopPoint()
            .enterPassword("32283228")
            .returnKeyBoard()
    }
}
