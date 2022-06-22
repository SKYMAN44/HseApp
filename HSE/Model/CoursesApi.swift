//
//  CoursesApi.swift
//  HSE
//
//  Created by Дмитрий Соколов on 18.06.2022.
//

import Foundation

public struct CourseCreation {
    let courseName: String
    let courseDescription: String
}
extension CourseCreation: Codable {}


public struct CourseShort {
    let id: Int
    let courseName: String
}
extension CourseShort: Codable {}


public typealias CourseList = [CourseShort]


public struct CourseListApiResponse {
    let courses: CourseList
}
extension CourseListApiResponse: Codable {}


public struct CourseApiResponse {
    let id: Int
    let courseName: String
    let courseDesc: String
    let ownerId: Int
}

extension CourseApiResponse: Decodable {}
