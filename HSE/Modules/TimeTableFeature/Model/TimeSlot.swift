//
//  Schedule.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation

struct TimeSlot {
    let id: Int
    let timeStart: String
    let timeEnd: String
    let type: String
    let subjectName: String
    let visitType: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case timeStart
        case timeEnd
        case subjectName = "lessonName"
        case type = "lessonType"
        case visitType = "isOnline"
    }
}

extension TimeSlot {
    public init(from timeSlot: TimeSlot, convertDates: Bool) {
        if convertDates {
            self.init(
                id: timeSlot.id,
                timeStart: timeSlot.timeStart.getHoursAndMinutesTimeString(),
                timeEnd: timeSlot.timeEnd.getHoursAndMinutesTimeString(),
                type: timeSlot.type,
                subjectName: timeSlot.subjectName,
                visitType: timeSlot.visitType
            )
        } else {
            self.init(
                id: timeSlot.id,
                timeStart: timeSlot.timeStart,
                timeEnd: timeSlot.timeEnd,
                type: timeSlot.type,
                subjectName: timeSlot.subjectName,
                visitType: timeSlot.visitType
            )
        }
    }
}

extension TimeSlot: Hashable { }
extension TimeSlot: Decodable { }
