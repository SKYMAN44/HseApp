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
    let schedule: [Schedule]
    
    
    static let days: [ScheduleDay] = [
        ScheduleDay(day: "THURSDAY, JANUARY 10", schedule: Schedule.array),
        ScheduleDay(day: "THURSDAY, JANUARY 11", schedule: Schedule.array),
        ScheduleDay(day: "THURSDAY, JANUARY 12", schedule: Schedule.array),
        ScheduleDay(day: "THURSDAY, JANUARY 13", schedule: Schedule.array),
        ScheduleDay(day: "THURSDAY, JANUARY 14", schedule: Schedule.array),
    ]
}
