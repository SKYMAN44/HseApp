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
    let type: DeadlineType
    let subjectName: String
    let assigmentName: String
    let deadlineTime: String
    let sumbisionTIme: String
    
}

extension Deadline: Decodable { }

extension Deadline: Hashable { }
