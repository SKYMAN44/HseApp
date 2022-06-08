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
    let id: Int = Int.random(in: 0...100)
    let deadlineType: DeadlineType
    let subjectName: String = "SomeName"
    let assignmentName: String
    let deadlineTime: String
    let submissionTime: String?
}

extension Deadline: Decodable { }
extension Deadline: Hashable { }
