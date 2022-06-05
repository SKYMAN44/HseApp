//
//  LoginEndPoint.swift
//  HSE
//
//  Created by Дмитрий Соколов on 31.05.2022.
//

import Foundation

public enum AuthApi {
    case login(LoginInfo)
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
        if case .login(let info) = self {
            return .requestParameters(bodyParameters: ["email": info.email,"password": info.password, "role": info.role.rawValue], urlParameters: nil)
        } else {
            return .requestParameters(bodyParameters: ["email": "","password": "", "role": ""], urlParameters: nil)
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
