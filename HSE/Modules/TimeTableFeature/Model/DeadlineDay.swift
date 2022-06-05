//
//  DeadlineDay.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation

struct DeadlineDay {
    let day: String
    let assignments: [Deadline]
}

extension DeadlineDay: Decodable { }
extension DeadlineDay: Hashable { }
