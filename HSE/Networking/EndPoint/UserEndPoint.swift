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
        return  URL(string:"https://hse-backend-test.herokuapp.com/users")!
    }
    var path: String {
        return "/profile"
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        return .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .jsonEncoding, urlParameters: nil, additionHeaders: headers)
    }
    
    var headers: HTTPHeaders? {
        guard let token = KeychainHelper.shared.read(
            service: "HSESOCIAL",
            account: "account",
            type: TokenJWT.self
        ) else {
            return nil
        }
        return ["authorization":"Bearer \(token.token)"]
    }
}
