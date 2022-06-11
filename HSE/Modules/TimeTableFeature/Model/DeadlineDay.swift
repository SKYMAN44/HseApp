//
//  DeadlineDay.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation

typealias DeadlineDictionary = [String: [Deadline]]

struct DeadlinesApiResponse {
    var pageNum: Int
    var assignments: DeadlineDictionary
}

extension DeadlinesApiResponse: Hashable {}
extension DeadlinesApiResponse: Decodable {}
