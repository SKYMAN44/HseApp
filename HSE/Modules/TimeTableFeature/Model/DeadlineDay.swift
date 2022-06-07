//
//  DeadlineDay.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation

typealias DeadlineDictionary = [String: [TimeSlot]]

struct DeadlineApiResponse {
    var pageNum: Int
    var deadlines: DeadlineDictionary
}

extension DeadlineApiResponse: Hashable {}
extension DeadlineApiResponse: Decodable {}

struct DeadlineDay {
    let day: String
    let assignments: [Deadline]
}

extension DeadlineDay: Decodable { }
extension DeadlineDay: Hashable { }
