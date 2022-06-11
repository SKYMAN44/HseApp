//
//  AuthProtocols.swift
//  HSE
//
//  Created by Дмитрий Соколов on 05.06.2022.
//

import UIKit

protocol LoginScreen: UIViewController {
    var isAnimating: Bool { get set }
    
    func showIncorrectDataWarning()
}

protocol LoginLogic {
    init(_ loginScreen: LoginScreen)
    
    func loginButtonPressed(_ email: String?, _ password: String?, _ roleNumber: Int)
}
