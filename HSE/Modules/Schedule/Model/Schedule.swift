//
//  Schedule.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation

struct Schedule {
    
    let timeStart: String
    let timeEnd: String
    let type: String
    let name: String
    let visitType: String
    
    
    static let array: [Schedule] = [ Schedule(timeStart: "10:30", timeEnd: "10:30", type: "Lecture", name: "Machine Learning", visitType: "Online"),
        Schedule(timeStart: "10:30", timeEnd: "10:30", type: "Lecture", name: "Machine Learning", visitType: "Online"),
        Schedule(timeStart: "10:30", timeEnd: "10:30", type: "Lecture", name: "Machine Learning", visitType: "Online"),
        Schedule(timeStart: "10:30", timeEnd: "10:30", type: "Lecture", name: "Machine Learning", visitType: "Online"),
        Schedule(timeStart: "10:30", timeEnd: "10:30", type: "Lecture", name: "Machine Learning", visitType: "Online")
    ]
}
