//
//  ScheduleEndPoint.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.02.2022.
//

import Foundation

public enum ScheduleAPI {
    case mySchedule(page: Int)
//    case currentSchedule(id: Int)
}

extension ScheduleAPI: EndPointType {
    var baseURL: URL {
        switch BaseNetworkManager.environment {
        case .local:
            return URL(string:"https://my-json-server.typicode.com/SKYMAN44/FAKEJSONSERVER/timetable/")!
        case .production:
            return URL(string:"https://hse-backend-test.herokuapp.com")!
        case .test:
            return URL(string:"https://my-json-server.typicode.com/SKYMAN44/FAKEJSONSERVER/timetable/")!
        }
    }
    
    var path: String {
        if case .mySchedule(_) = self {
            return "/schedule"
        } else {
            return "1/schedule"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        if case .mySchedule(let page) = self {
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
        if case .mySchedule(_) = self {
            guard let token = KeychainHelper.shared.read(
                service: KeychainHelper.defaultService,
                account: KeychainHelper.defaultAccount,
                type: TokenJWT.self
            ) else {
                return nil
            }
            return ["Authorization":"Bearer \(token.token)"]
        }
        return nil
    }
}
