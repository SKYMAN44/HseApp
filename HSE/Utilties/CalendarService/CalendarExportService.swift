//
//  CalendarExportService.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.06.2022.
//

import Foundation
import EventKit


class CalendarExportService {
    static let shared = CalendarExportService()

    private init() {}

    private let eventStore = EKEventStore()

    private func requestAccess() {
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted {
                self.save()
            }
        }
    }

    private func save() {
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
        } catch {

        }
    }

    public func saveEvents() {
        requestAccess()
    }
}
