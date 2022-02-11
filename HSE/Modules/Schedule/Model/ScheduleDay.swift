//
//  ScheduleDay.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation

// temp parameters
struct ScheduleDay {
    
    let day: String
    let schedule: [TimeSlot]
    
    
    static let days: [ScheduleDay] = [
        ScheduleDay(day: "THURSDAY, JANUARY 10", schedule: TimeSlot.array),
        ScheduleDay(day: "THURSDAY, JANUARY 11", schedule: TimeSlot.array),
        ScheduleDay(day: "THURSDAY, JANUARY 12", schedule: TimeSlot.array),
        ScheduleDay(day: "THURSDAY, JANUARY 13", schedule: TimeSlot.array),
        ScheduleDay(day: "THURSDAY, JANUARY 14", schedule: TimeSlot.array),
    ]
}
