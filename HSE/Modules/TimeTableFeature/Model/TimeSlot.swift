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
    let visitType: String
}

extension TimeSlot: Hashable { }
extension TimeSlot: Decodable { }
