//
//  String+Date.swift
//  HSE
//
//  Created by Дмитрий Соколов on 07.06.2022.
//

import Foundation

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
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "EEEE,MMMM dd"
        guard let date = self.convertStringToDate() else { return "" }
        let weekDay = dateFormatter.string(from: date).capitalized
        
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
