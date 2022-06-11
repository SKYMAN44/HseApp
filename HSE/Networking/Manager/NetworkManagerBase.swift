//
//  NetworkManagerBaseClass.swift
//  HSE
//
//  Created by Дмитрий Соколов on 07.06.2022.
//

import Foundation

internal enum NetworkEnvironment {
    case production
    case test
    case local
}

// TODO: add image fetching(caching) when backend ready
open class BaseNetworkManager {
    static let environment: NetworkEnvironment = .production
    
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
    
    internal func handleNetworkRequest(_ response: HTTPURLResponse) -> Result<String> {
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkingResponse.authError.rawValue)
        case 501...599: return .failure(NetworkingResponse.badrequest.rawValue)
        case 600: return .failure(NetworkingResponse.outdated.rawValue)
        default: return .failure(NetworkingResponse.failed.rawValue)
        }
    }
    
    internal func processRequestResponse<T:Decodable>(
        _ data: Data?,
        _ response: URLResponse?,
        _ error: Error?,
        _ ResponseType: T.Type,
        completion: @escaping (T?, String?) -> ()
    ) {
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
//                    let string = String(data: responseData, encoding: .utf8)
//                    print(string)
                    let apiResponse = try JSONDecoder().decode(T.self, from: responseData)
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
