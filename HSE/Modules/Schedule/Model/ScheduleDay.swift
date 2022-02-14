//
//  ScheduleDay.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation

struct ScheduleDay: Decodable {
    
    let day: String
    let timeSlot: [TimeSlot]
}

extension ScheduleDay: Hashable { }

