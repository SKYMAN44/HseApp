//
//  Deadline.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation

// temp parameters
struct Deadline: Decodable{
    
    let id: Int
    let subjectName: String
    let assigmentName: String
    let deadlineTime: String
    let sumbisionTIme: String
    
}

extension Deadline: Hashable { }
