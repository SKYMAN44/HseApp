//
//  DeadlineDay.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation

// temp parameters
struct DeadlineDay: Decodable, Hashable {
    
    let day: String
    let assignments: [Deadline]
}
