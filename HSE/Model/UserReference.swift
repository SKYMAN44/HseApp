//
//  User.swift
//  HSE
//
//  Created by Дмитрий Соколов on 23.02.2022.
//

import Foundation

struct UserReference {
    let id: Int
    let role: UserType
    let name: String
    let image: URL?

    init(
        id: Int,
        name: String,
        role: UserType = .student,
        image: URL? = nil
    ) {
        self.role = role
        self.id = id
        self.name = name
        self.image = image
    }
}

extension UserReference: Codable { }
extension UserReference: Hashable { }
