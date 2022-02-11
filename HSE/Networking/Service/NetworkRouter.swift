//
//  NetworkRouter.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.02.2022.
//

import Foundation


public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?,_ error: Error?) -> ()


protocol NetworkRouter {
    // helps to handle any endpoint confirming to EndPointType protocol
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}
