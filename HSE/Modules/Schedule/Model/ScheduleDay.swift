//
//  ScheduleDay.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation

// temp parameters

struct Day: Decodable, Hashable {
    let day: String
}

struct ScheduleDay: Decodable {
    
    let day: String
    let timeSlot: [TimeSlot]
}

extension ScheduleDay: Hashable {
    
}

