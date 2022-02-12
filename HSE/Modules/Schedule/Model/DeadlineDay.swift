//
//  DeadlineDay.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation

// temp parameters
struct DeadlineDay: Decodable {
    
    let day: String
    let assignments: [Deadline]
    
    
    static let days: [DeadlineDay] = [
        DeadlineDay(day: "THURSDAY, JANUARY 10", assignments: Deadline.array),
        DeadlineDay(day: "THURSDAY, JANUARY 11", assignments: Deadline.array),
        DeadlineDay(day: "THURSDAY, JANUARY 12", assignments: Deadline.array),
        DeadlineDay(day: "THURSDAY, JANUARY 13", assignments: Deadline.array)
    ]
}
