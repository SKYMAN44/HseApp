//
//  LoginScreen.swift
//  HSEUITests
//
//  Created by Дмитрий Соколов on 11.06.2022.
//

import Foundation
import XCTest

final class LoginScreen: BaseScreen {
    private enum Identifier: String, CaseIterable {
        case loginButton = "LOGIN_BUTTON"
        case loginProblemButton = "LOGIN_PROBLEM_BUTTON"
        case emailTextField = "EMAIL_TEXTFIELD"
        case passwordTextField = "PASSWORD_TEXTFIELD"
        case segmentController = "Segment_Controll"
    }

    private enum KeyboardIdentifier: String {
        case keyboardReturn = "Return"
        case keyboardDelete = "delete"
    }

    private func elementById(_ id: Identifier) -> XCUIElement {
        switch id {
        case .loginButton, .loginProblemButton:
            return app.buttons[id.rawValue]
        case .emailTextField:
            return app.textFields[id.rawValue]
        case .passwordTextField:
            return app.secureTextFields[id.rawValue]
        case .segmentController:
            return app.firstMatch
        }
    }

    private func keyboardElement(_ id: KeyboardIdentifier) -> XCUIElement {
        app.keyboards.buttons[id.rawValue]
    }

    // MARK: - TextField Manipulations
    @discardableResult
    func enterEmail(_ email: String, _ withTap: Bool = true) -> Self {
        let textField = elementById(.emailTextField)
        if withTap {
            textField.tap()
        }
        textField.typeText(email)

        return self
    }

    @discardableResult
    func enterPassword(_ password: String, _ withTap: Bool = true) -> Self {
        let textField = elementById(.passwordTextField)
        if withTap {
            textField.tap()
        }
        textField.typeText(password)

        return self
    }

    @discardableResult func returnKeyBoard() -> Self {
        keyboardElement(.keyboardReturn).tap()

        return self
    }

    @discardableResult
    func pressLogin() -> Self {
        let button = elementById(.loginButton)
        button.tap()

        return self
    }

    @discardableResult
    func touchTopPoint() -> Self {
        let scrollViewsQuery = app.scrollViews
        let element = scrollViewsQuery.children(matching: .other).element(boundBy: 0)
        element.tap()

        return self
    }
}
