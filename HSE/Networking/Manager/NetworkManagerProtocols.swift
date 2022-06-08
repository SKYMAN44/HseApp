//
//  NetworkManagerProtocols.swift
//  HSE
//
//  Created by Дмитрий Соколов on 07.06.2022.
//

import Foundation

protocol NetworkManagerBase {
    func cancelRequest()
}

protocol ScheduleNetworkManager: NetworkManagerBase {
    func getSchedule(_ page: Int, completion: @escaping (_ schedule: ScheduleApiResponse?, _ error: String?) -> ())
}

protocol DeadlineNetworkManager: NetworkManagerBase {
    func getDeadline(_ page: Int, completion: @escaping (_ schedule: DeadlineApiResponse?, _ error: String?) -> ())
}

protocol LoginNetworkManager: NetworkManagerBase {
    func login(_ loginInfo: LoginInfo, completion: @escaping (_ token: TokenJWT?, _ error: String?) -> ())
}

protocol UserNetworkManager: NetworkManagerBase {
    func getMyUser(completion: @escaping (_ userRef: UserApiResponse?, _ error: String?) -> ())
}
