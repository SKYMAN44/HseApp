//
//  ParameterEncoding.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.02.2022.
//

import Foundation


public typealias Parameters = [String:String]


public protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum NetworkError: String, Error {
    case ParametersNil = "Parameters are nil"
    case encodingFailed = "Failed to encode parameters"
    case missingURL = "URL = nil "
}
