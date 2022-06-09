//
//  Deadline.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation

enum DeadlineType: String, Decodable {
    case hw = "hw"
    case cw = "cw"
}

struct Deadline {
    let id: Int
    let deadlineType: DeadlineType
    let courseName: String
    let assignmentName: String
    let deadlineTime: String
    let submissionTime: String?
}

extension Deadline {
    public init(from deadline: Deadline, convertDates: Bool) {
        var deadlineTimeToDisplay: String
        var submissionTimeToDisplay: String?
        if(convertDates) {
            deadlineTimeToDisplay = deadline.deadlineTime.getHoursAndMinutesTimeString()
            submissionTimeToDisplay = deadline.submissionTime?.getHoursAndMinutesTimeString()
        } else {
            deadlineTimeToDisplay = deadline.deadlineTime
            submissionTimeToDisplay = deadline.submissionTime
        }
        self.init(
            id: deadline.id,
            deadlineType: deadline.deadlineType,
            courseName: deadline.courseName,
            assignmentName: deadline.assignmentName,
            deadlineTime: deadlineTimeToDisplay,
            submissionTime: submissionTimeToDisplay
        )
    }
}

extension Deadline: Decodable {}
extension Deadline: Hashable {}
