//
//  ScheduleDay.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation

// temp parameters
struct ScheduleDay: Decodable {
    
    let day: String
    let timeSlot: [TimeSlot]
    
    
    static let days: [ScheduleDay] = [
        ScheduleDay(day: "THURSDAY, JANUARY 10", timeSlot: TimeSlot.array),
        ScheduleDay(day: "THURSDAY, JANUARY 11", timeSlot: TimeSlot.array),
        ScheduleDay(day: "THURSDAY, JANUARY 12", timeSlot: TimeSlot.array),
        ScheduleDay(day: "THURSDAY, JANUARY 13", timeSlot: TimeSlot.array),
        ScheduleDay(day: "THURSDAY, JANUARY 14", timeSlot: TimeSlot.array),
    ]
}
