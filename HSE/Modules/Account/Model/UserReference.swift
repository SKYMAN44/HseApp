//
//  User.swift
//  HSE
//
//  Created by Дмитрий Соколов on 23.02.2022.
//

import Foundation

struct UserReference {
    let name: String
    let image: URL?
}

extension UserReference: Decodable { }

extension UserReference: Hashable { }
