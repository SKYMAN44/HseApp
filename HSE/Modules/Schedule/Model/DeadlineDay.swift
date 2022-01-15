//
//  DeadlineDay.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation

// temp parameters
struct DeadlineDay {
    
    let day: String
    let deadlines: [Deadline]
    
    
    static let days: [DeadlineDay] = [
        DeadlineDay(day: "THURSDAY, JANUARY 10", deadlines: Deadline.array),
        DeadlineDay(day: "THURSDAY, JANUARY 11", deadlines: Deadline.array),
        DeadlineDay(day: "THURSDAY, JANUARY 12", deadlines: Deadline.array),
        DeadlineDay(day: "THURSDAY, JANUARY 13", deadlines: Deadline.array)
    ]
}
