//
//  TokenModel.swift
//  HSE
//
//  Created by Дмитрий Соколов on 07.06.2022.
//

import Foundation

struct TokenJWT: Codable {
    var token: String
}

public struct LoginInfo {
    let email: String
    let password: String
    let role: UserType
}

extension LoginInfo: Codable {}
