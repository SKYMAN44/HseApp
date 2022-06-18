//
//  CoursesEndPoint.swift
//  HSE
//
//  Created by Дмитрий Соколов on 18.06.2022.
//

import Foundation


public enum CoursesApi {
    case getCourses
    case getCourseById(Int)
    case createCourse(CourseCreation)
}

extension CoursesApi: EndPointType {
    var baseURL: URL {
        if let url =  URL(string: "https://hse-backend-test.herokuapp.com") {
            return url
        } else {
            fatalError("Couldn't construct url")
        }
    }

    var path: String {
        switch self {
        case .getCourses:
            return "/courses"
        case .getCourseById(let int):
            return ""
        case .createCourse:
            return "/courses"
        }
    }

    var httpMethod: HTTPMethod {
        if case .createCourse = self {
            return .post
        } else {
            return .get
        }
    }

    var task: HTTPTask {
        if case .createCourse(let course) = self {
            return .requestParameters(
                bodyParameters: [
                    "courseName": course.courseName,
                    "courseDescription": course.courseDescription
                ],
                bodyEncoding: .jsonEncoding,
                urlParameters: nil
            )
        } else {
            return .request
        }
    }

    var headers: HTTPHeaders? {
        guard let token = KeychainHelper.shared.read(
            service: KeychainHelper.defaultService,
            account: KeychainHelper.defaultAccount,
            type: TokenJWT.self
        ) else {
            return nil
        }
        return ["authorization":"Bearer \(token.token)"]
    }


}
