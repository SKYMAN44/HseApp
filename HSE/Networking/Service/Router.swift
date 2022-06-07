//
//  Router.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.02.2022.
//

import Foundation

class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        // create url session and send request to server
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request) { (data, response, error) in
                completion(data, response, error)
            }
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    private func buildRequest(from route: EndPoint) throws -> URLRequest {
        // construct proper URL request given desired endpoint
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                try bodyEncoding.encode(urlRequest: &request, bodyParameters: bodyParameters, urlParameters: urlParameters)
            case .requestParametersAndHeaders(
                let bodyParameters,
                let bodyEncoding,
                let urlParameters,
                let additionalHeaders
            ):
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try bodyEncoding.encode(urlRequest: &request, bodyParameters: bodyParameters, urlParameters: urlParameters)
            }
            return request
        } catch {
            throw error
        }
    }
    
    private func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    public func cancel() {
        guard task != nil else {
            return
        }
        self.task?.cancel()
    }
}
