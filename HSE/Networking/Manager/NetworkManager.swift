//
//  NetworkManager.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.02.2022.
//

import Foundation


struct NetworkManager {
    static let environment: NetworkEnvironment = .local
    static let ApiKey = "NO_key"
    private let router = Router<ScheduleAPI>()
    private let routerD = Router<DeadLineAPI>()
    
    enum NetworkingResponse: String {
        case success
        case authError = "Authentication error"
        case badrequest = "Bad request"
        case outdated = "url is outdated"
        case failed = "Network request failed"
        case noData = "no data returned"
        case unableToDecode = "couldn't decode data"
    }
    
    enum Result<String> {
        case success
        case failure(String)
    }
    
    private func handleNetworkRequest(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkingResponse.authError.rawValue)
        case 501...599: return .failure(NetworkingResponse.badrequest.rawValue)
        case 600: return .failure(NetworkingResponse.outdated.rawValue)
        default: return .failure(NetworkingResponse.failed.rawValue)
        }
    }
    
    public func getSchedule(completion: @escaping (_ schedule: [ScheduleDay]?, _ error: String?) -> () ) {
        router.request(.currentSchedule(id: 1)) { data, response, error in
            if error != nil {
                completion(nil, "Check Network Connection")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkRequest(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkingResponse.noData.rawValue)
                        return 
                    }
                    
                    do {
                        let apiResponse = try JSONDecoder().decode([ScheduleDay].self, from: responseData)
                        completion(apiResponse, nil)
                    } catch {
                        completion(nil, NetworkingResponse.unableToDecode.rawValue)
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    public func getDeadline(completion: @escaping (_ schedule: [DeadlineDay]?, _ error: String?) -> () ) {
        routerD.request(.deadlines(id: 1)) { data, response, error in
            if error != nil {
                completion(nil, "Check Network Connection")
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkRequest(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkingResponse.noData.rawValue)
                        return
                    }
                    
                    do {
                        let apiResponse = try JSONDecoder().decode([DeadlineDay].self, from: responseData)
                        completion(apiResponse, nil)
                    } catch {
                        completion(nil, NetworkingResponse.unableToDecode.rawValue)
                    }
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    public func cancelSchedule() {
        router.cancel()
    }
    
    public func cancelDeadline() {
        routerD.cancel()
    }
}

