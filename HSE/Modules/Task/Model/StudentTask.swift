//
//  Task.swift
//  HSE
//
//  Created by Дмитрий Соколов on 23.02.2022.
//

import Foundation

struct TaskDescription {
    let courseName: String
    let name: String
    let discription: String
}

extension TaskDescription: Decodable { }

struct StudentTask {
    let taskDescription: TaskDescription
    let publicationTime: String
    let deadlineTime: String
    let taskFiles: [File]
    let postedBy: UserReference
    let submissionFiles: [File]
    let submissionTime: String?
}

extension StudentTask: Decodable { }
