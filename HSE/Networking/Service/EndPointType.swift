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
//    TBD
    
}
