//
//  LoginEndPoint.swift
//  HSE
//
//  Created by Дмитрий Соколов on 31.05.2022.
//

import Foundation

public enum AuthApi {
    case login(String)
}

extension AuthApi: EndPointType {
    var baseURL: URL {
        if let url =  URL(string: "https://hse-backend-test.herokuapp.com/auth") {
            return url
        } else {
            fatalError("Couldn't construct url")
        }
       
    }
    
    var path: String {
        if case .login(_) = self {
            return "/login"
        } else {
            return "/login"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .post
    }
    
    var task: HTTPTask {
        return .requestParameters(bodyParameters: ["email":"olivan139@gmail.com","password":"12345678"], urlParameters: nil)
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
