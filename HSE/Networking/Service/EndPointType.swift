//
//  EndPointType.swift
//  HSE
//
//  Created by Дмитрий Соколов on 17.01.2022.
//

import Foundation


protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
