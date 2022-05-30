//
//  UserEndPoint.swift
//  HSE
//
//  Created by Дмитрий Соколов on 29.05.2022.
//

import Foundation

public enum UserAPI {
    case user
}

extension UserAPI: EndPointType {
    var baseURL: URL {
        return  URL(string:"https://my-json-server.typicode.com/SKYMAN44/FAKEJSONSERVER/timetable/")!
    }
    
    var path: String {
        return ""
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        return .request
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
