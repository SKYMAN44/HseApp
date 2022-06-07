//
//  DeadLineEndPoint.swift
//  HSE
//
//  Created by Дмитрий Соколов on 12.02.2022.
//

import Foundation


public enum DeadLineAPI {
    case deadlines(id: Int)
}

extension DeadLineAPI: EndPointType {
    var baseURL: URL {
        switch BaseNetworkManager.environment {
        case .local:
            return URL(string:"https://my-json-server.typicode.com/SKYMAN44/FAKEJSONSERVER/deadline/")!
        case .production:
            return URL(string:"https://my-json-server.typicode.com/SKYMAN44/FAKEJSONSERVER/deadline/")!
        case .test:
            return URL(string:"https://my-json-server.typicode.com/SKYMAN44/FAKEJSONSERVER/deadline/")!
        }
    }
    
    var path: String {
        if case .deadlines(let id) = self {
            return "\(id)/deadlines"
        } else {
            return "1/deadlines"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        if case .deadlines(_) = self {
            return .request
        } else {
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
