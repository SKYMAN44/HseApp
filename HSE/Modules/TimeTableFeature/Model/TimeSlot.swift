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

extension String {
    func getHoursAndMinutesTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let dateObj = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = "HH:mm"
        // Convert Date to String
        return dateFormatter.string(from: dateObj)
    }
    
    func getTodayWeekDay()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        guard let date = self.convertStringToDate() else { return "" }
        let weekDay = dateFormatter.string(from: date)
        
        return weekDay
      }
    
    func convertStringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: self)
    }
}

extension Date {
    func convertFullDateToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: self)
    }
}
