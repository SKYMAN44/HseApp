//
//  Course.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.01.2022.
//

import Foundation


struct Course {
    
    let id: Int?
    let name: String
    
    static let  courses = [Course(id: 1, name: "Algebra"),
                           Course(id: 2, name: "TSSP"),
                           Course(id: 3, name: "Algebra"),
                           Course(id: 4, name: "TSSP"),
                           Course(id: 5, name: "Algebra"),
                           Course(id: 6, name: "TSSP")
    ]
}
