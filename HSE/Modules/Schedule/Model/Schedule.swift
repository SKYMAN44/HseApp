//
//  Schedule.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation

// temp parameters
struct Schedule {
    
    let timeStart: String
    let timeEnd: String
    let type: String
    let subjectName: String
    let visitType: String
    
    
    static let array: [Schedule] = [ Schedule(timeStart: "10:30", timeEnd: "10:30", type: "Lecture", subjectName: "Machine Learning", visitType: "Online"),
        Schedule(timeStart: "10:30", timeEnd: "10:30", type: "Lecture", subjectName: "Time Series and Stochatic Processes (eng)", visitType: "Online"),
        Schedule(timeStart: "10:30", timeEnd: "10:30", type: "Lecture", subjectName: "Machine Learning", visitType: "Online"),
        Schedule(timeStart: "10:30", timeEnd: "10:30", type: "Lecture", subjectName: "Machine Learning", visitType: "Online"),
        Schedule(timeStart: "10:30", timeEnd: "10:30", type: "Lecture", subjectName: "Machine Learning", visitType: "Online")
    ]
}
