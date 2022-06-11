//
//  ScheduleDay.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation

typealias ScheduleDictonary = [String: [TimeSlot]]

struct ScheduleApiResponse {
    var pageNum: Int
    var timeTable: ScheduleDictonary
}

extension ScheduleApiResponse: Hashable {}
extension ScheduleApiResponse: Decodable {}
