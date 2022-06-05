//
//  User.swift
//  HSE
//
//  Created by Дмитрий Соколов on 29.05.2022.
//

import Foundation

struct User {
    let userMainInfo: UserGeneralInfo
    let detailInfo: UserDetailedInfo?
    
    static let testUser = User(
        userMainInfo: UserGeneralInfo(
            mainInfo: UserReference(id: 1, name: "Dmitrii Sokolov", role: .student, image: nil),
            email: "dmsokolov@edu.hse.ru",
            address: "Покровский бульвар, 11",
            group: "bpad193"
        ),
        detailInfo: UserDetailedInfo()
    )
}

extension User: Codable { }
extension User: Hashable { }

struct UserGeneralInfo {
    let mainInfo: UserReference
    let email: String
    let address: String
    let group: String
}

extension UserGeneralInfo: Codable {}
extension UserGeneralInfo: Hashable {}

struct UserDetailedInfo {
    var someINfo = "Stringsssssss;fdfsfs1323242"
}

extension UserDetailedInfo: Codable {}
extension UserDetailedInfo: Hashable {}

public struct LoginInfo {
    let email: String
    let password: String
    let role: UserType
}

extension LoginInfo: Codable {}
