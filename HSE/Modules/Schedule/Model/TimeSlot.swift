//
//  Schedule.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation

// temp parameters
struct TimeSlot {
    
    let timeStart: String
    let timeEnd: String
    let type: String
    let subjectName: String
    let visitType: String
    
    
    static let array: [TimeSlot] = [ TimeSlot(timeStart: "10:30", timeEnd: "10:30", type: "Lecture", subjectName: "Machine Learning", visitType: "Online"),
        TimeSlot(timeStart: "10:30", timeEnd: "10:30", type: "Lecture", subjectName: "Time Series and Stochatic Processes (eng)", visitType: "Online"),
        TimeSlot(timeStart: "10:30", timeEnd: "10:30", type: "Lecture", subjectName: "Machine Learning", visitType: "Online"),
        TimeSlot(timeStart: "10:30", timeEnd: "10:30", type: "Lecture", subjectName: "Machine Learning", visitType: "Online"),
        TimeSlot(timeStart: "10:30", timeEnd: "10:30", type: "Lecture", subjectName: "Machine Learning", visitType: "Online")
    ]
}
