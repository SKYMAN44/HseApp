//
//  ScheduleEndPoint.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.02.2022.
//

// https://my-json-server.typicode.com/SKYMAN44/FAKEJSONSERVER
import Foundation

enum NetworkEnvironment {
    case production
    case test
    case local
}

public enum ScheduleAPI {
    case currentSchedule(id: Int)
}

extension ScheduleAPI: EndPointType {
    var baseURL: URL {
        switch NetworkManager.environment {
        case .local:
            return URL(string:"https://my-json-server.typicode.com/SKYMAN44/FAKEJSONSERVER/timetable/")!
        case .production:
            return URL(string:"https://my-json-server.typicode.com/SKYMAN44/FAKEJSONSERVER/timetable/")!
        case .test:
            return URL(string:"https://my-json-server.typicode.com/SKYMAN44/FAKEJSONSERVER/timetable/")!
        }
    }
    
    var path: String {
        if case .currentSchedule(let id) = self {
            return "\(id)/schedule"
        } else {
            return "1/schedule"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        if case .currentSchedule(let id) = self {
            return .request
        } else {
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    
}
