//
//  DeadLineEndPoint.swift
//  HSE
//
//  Created by Дмитрий Соколов on 12.02.2022.
//

import Foundation


public enum DeadLineAPI {
    case deadlines(page: Int)
    case deadlineDetail(id: Int)
    case courseDeadlines(courseId: Int)
}

extension DeadLineAPI: EndPointType {
    var baseURL: URL {
        switch BaseNetworkManager.environment {
        case .local:
            return URL(string:"https://my-json-server.typicode.com/SKYMAN44/FAKEJSONSERVER/deadline/")!
        case .production:
            return URL(string:"https://hse-backend-test.herokuapp.com")!
        case .test:
            return URL(string:"https://my-json-server.typicode.com/SKYMAN44/FAKEJSONSERVER/deadline/")!
        }
    }
    
    var path: String {
        if case .deadlines(_) = self {
            return "/assignments"
        } else if case .courseDeadlines = self {
            return "/assignments/assignments-list"
        } else {
            return "/assignments/details"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .deadlines(let page):
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: ["page": String(page)]
            )
        case .deadlineDetail(let id):
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: ["id": String(id)]
            )
        case .courseDeadlines(let courseId):
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: ["id": String(courseId)]
            )
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
        return ["Authorization":"Bearer \(token.token)"]
    }
}
