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

extension TaskDescription: Hashable { }

extension TaskDescription: Decodable { }

struct StudentTask {
    let taskDescription: TaskDescription
    let publicationTime: String
    let deadlineTime: String
    let taskFiles: [File]
    let postedBy: UserReference
    var submissionFiles: [File]
    var submissionTime: String?
}

extension StudentTask: Decodable { }

extension StudentTask {
    static let example = StudentTask(taskDescription: TaskDescription(courseName: "", name: "", discription: ""), publicationTime: "", deadlineTime: "", taskFiles: [], postedBy: UserReference(id: 0, name: "", image: nil), submissionFiles: [], submissionTime: "")
}
