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
            id: 1,
            name: "",
            surname: "",
            patron: "",
            groupId: "",
            email: "",
            faculty: "",
            currentRole: .student,
            profilePicURL: ""
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
    let id: Int
    let name: String
    let surname: String
    let patron: String?
    let groupId: String?
    let email: String
    let faculty: String
    let currentRole: UserType
    let profilePicURL: String?
}

extension UserApiResponse: Codable {}
extension UserApiResponse: Hashable {}
