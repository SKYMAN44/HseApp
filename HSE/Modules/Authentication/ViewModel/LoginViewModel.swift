//
//  LoginViewModel.swift
//  HSE
//
//  Created by Дмитрий Соколов on 05.06.2022.
//

import Foundation
import UIKit

final class LoginViewModel: LoginLogic {
    private let networkM = NetworkManager()
    private let encryptedStorage = KeychainHelper.shared
    private weak var loginScreen: LoginScreen?
    private var email: String = ""
    private var password: String = ""
    private var role: UserType?
    
    // MARK: - Init
    init(_ loginScreen: LoginScreen) {
        self.loginScreen = loginScreen
    }
    
    // MARK: - Api Call
    private func makeLoginCall(_ loginInfo: LoginInfo) {
        loginScreen?.isAnimating = true
        networkM.login(loginInfo) { [weak self] (user, error) in
            if error != nil {
                self?.presentNetworkError(error, title: "Failed to Login")
            } else {
                self?.encryptedStorage.save(user, service: "HSESOCIAL", account: "account")
                self?.navigateToApp()
            }
        }
    }
    
    // MARK: - Navigation
    private func navigateToApp() {
        guard let role = role else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loginScreen?.isAnimating = false
            let tabVC = TabBarBaseController(role)
            tabVC.modalPresentationStyle = .fullScreen
            self.loginScreen?.present(tabVC, animated: true, completion: nil)
        }
    }
    
    private func userTypeByNumber(_ num: Int) -> UserType {
        switch num {
        case 0:
            return .professor
        case 1:
            return .ta
        case 2:
            return .student
        default:
            return .student
        }
    }
    
    // MARK: - Interactions
    public func loginButtonPressed(_ email: String?,_ password: String?, _ roleNumber: Int) {
        if let email = email, let password = password {
            self.email = email
            self.password = password
            self.role = userTypeByNumber(roleNumber)
            validateInput()
        } else {
            showInputError(text: "Fields are Empty")
        }
    }
    
    private func validateInput() {
        guard !email.isEmpty && !password.isEmpty, let role = self.role
        else {
            showInputError(text: "Fields are empty")
            return
        }
        let info = LoginInfo(email: email, password: password, role: role)
        makeLoginCall(info)
    }
    
    // MARK: - Erorr Presentation
    private func showInputError(text: String) {
        loginScreen?.showIncorrectDataWarning()
    }
    
    private func presentNetworkError(_ error: String?, title: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loginScreen?.isAnimating = false
            let alert = UIAlertController(title: title, message: error ?? "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.loginScreen?.present(alert, animated: true, completion: nil)
        }
    }
}
