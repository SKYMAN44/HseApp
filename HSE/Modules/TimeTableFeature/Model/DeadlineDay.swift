//
//  DeadlineDay.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation

typealias DeadlineDictionary = [String: [Deadline]]

struct DeadlineApiResponse {
    var pageNum: Int
    var assignments: DeadlineDictionary
}

extension DeadlineApiResponse: Hashable {}
extension DeadlineApiResponse: Decodable {}
