//
//  Task.swift
//  HSE
//
//  Created by Дмитрий Соколов on 23.02.2022.
//

import Foundation

struct DeadlineDescriptionApiResponse {
    let id: Int
    let deadlineType: DeadlineType
    let assignmentName: String
    let courseName: String
    let description: String
    let deadlineTime: String
    let submissionTime: String?
    let createdAt: String
    let updatedAt: String
}

extension DeadlineDescriptionApiResponse: Codable {}

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
