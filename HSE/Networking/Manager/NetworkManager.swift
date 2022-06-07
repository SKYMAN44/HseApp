//
//  NetworkManager.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.02.2022.
//

import Foundation

final class TimeTableNetworkManager: BaseNetworkManager, ScheduleNetworkManager {
    var router = Router<ScheduleAPI>()
    
    func getSchedule(_ page: Int, completion: @escaping (ScheduleApiResponse?, String?) -> ()) {
        router.request(.mySchedule(page: page)) { [self] data, response, error in
            processRequestResponse(data, response, error, ScheduleApiResponse.self, completion: completion)
        }
    }
    
    public func cancelRequest() {
        router.cancel()
    }
}

final class AssignmentsNetworkManager: BaseNetworkManager, DeadlineNetworkManager {
    var router = Router<DeadLineAPI>()
    
    public func getDeadline(completion: @escaping ([DeadlineDay]?, String?) -> () ) {
        router.request(.deadlines(id: 1)) { [self] data, response, error in
            processRequestResponse(data, response, error, [DeadlineDay].self, completion: completion)
        }
    }
    
    public func cancelRequest() {
        router.cancel()
    }
}

final class AuthenticationNetworkManager: BaseNetworkManager, LoginNetworkManager {
    var router = Router<AuthApi>()
    
    public func login(_ loginInfo: LoginInfo, completion: @escaping (_ token: TokenJWT?, _ error: String?) -> ()) {
        router.request(.login(loginInfo)) { [self] data, response , error in
            processRequestResponse(data, response, error, TokenJWT.self, completion: completion)
        }
    }
    
    public func cancelRequest() {
        router.cancel()
    }
}

final class UserInfoNetworkManager: BaseNetworkManager, UserNetworkManager {
    var router = Router<UserAPI>()
    
    public func getMyUser(completion: @escaping (_ userRef: UserApiResponse?, _ error: String?) -> ()) {
        router.request(.user) { [self] data, response, error in
            processRequestResponse(data, response, error, UserApiResponse.self, completion: completion)
        }
    }
    
    public func cancelRequest() {
        router.cancel()
    }
}
