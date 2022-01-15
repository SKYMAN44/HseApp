//
//  Course.swift
//  HSE
//
//  Created by Дмитрий Соколов on 11.01.2022.
//

import Foundation


struct Course {
    
    public let id: Int
    public let title: String
    
    static let  courses = [Course(id: 1, title: "Linear Algebra"),
                           Course(id: 2, title: "TSSP"),
                           Course(id: 3, title: "Discrete Mathematics"),
                           Course(id: 4, title: "TSSP"),
                           Course(id: 5, title: "Algebra"),
                           Course(id: 6, title: "TSSP"),
                           Course(id: 7, title: "TSSP"),
                           Course(id: 8, title: "TSSP")
    ]
    
}
