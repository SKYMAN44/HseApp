//
//  User.swift
//  HSE
//
//  Created by Дмитрий Соколов on 29.05.2022.
//

import Foundation

struct User {
    let userMainInfo: UserApiResponse
    let detailInfo: UserDetailedInfo?
    
    static let testUser = User(
        userMainInfo: UserApiResponse(
            name: "",
            surname: "",
            patron: "",
            group: "",
            email: "",
            faculty: ""
        ),
        detailInfo: UserDetailedInfo()
    )
}

extension User: Codable { }
extension User: Hashable { }

struct UserDetailedInfo {
    var someINfo = "Stringsssssss;fdfsfs1323242"
}

extension UserDetailedInfo: Codable {}
extension UserDetailedInfo: Hashable {}


struct UserApiResponse {
    let name: String
    let surname: String
    let patron: String?
    let group: String
    let email: String
    let faculty: String
}

extension UserApiResponse: Codable {}
extension UserApiResponse: Hashable {}
