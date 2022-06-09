//
//  DeadLineEndPoint.swift
//  HSE
//
//  Created by Дмитрий Соколов on 12.02.2022.
//

import Foundation


public enum DeadLineAPI {
    case deadlines(page: Int)
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
        } else {
            return "/assignments"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        if case .deadlines(let page) = self {
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding,
                urlParameters: ["page": String(page)]
            )
        } else {
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        if case .deadlines(_) = self {
            guard let token = KeychainHelper.shared.read(
                service: KeychainHelper.defaultService,
                account: KeychainHelper.defaultAccount,
                type: TokenJWT.self
            ) else {
                return nil
            }
            return ["authorization":"Bearer \(token.token)"]
        }
        return nil
    }
}
