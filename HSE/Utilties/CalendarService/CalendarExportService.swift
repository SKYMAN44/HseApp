//
//  CalendarExportService.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.06.2022.
//

import Foundation
import EventKit

class CalendarExportService {
    private enum ExportError: String, Error {
        case failedToExport = "Failed to export"
        case accessNotGrandet = "No access to calendar"
    }

    private let eventStore = EKEventStore()

    static let shared = CalendarExportService()

    private init() {}

    private func requestAccess(completion: @escaping (Result<String, Error>) -> Void) {
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                self.save(completion: completion)
            } else {
                completion(.failure(ExportError.accessNotGrandet))
            }
        }
    }

    private func save(completion: @escaping (Result<String, Error>)-> Void) {
        // remove fake event to those which a passed as agruments
        guard let calendar = eventStore.defaultCalendarForNewEvents else { return }
        let event = EKEvent(eventStore: eventStore)
        event.title = "This is my test event"
        event.startDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        event.isAllDay = true
        event.endDate = event.startDate
        event.calendar = calendar
        do {
            try eventStore.save(event, span: .thisEvent, commit: true)
            completion(.success("Successfuly exported to calendar"))
        } catch {
            completion(.failure(ExportError.failedToExport))
        }
    }

    public func saveEvents(completion: @escaping (Result<String, Error>) -> Void) {
        requestAccess(completion: completion)
    }
}
