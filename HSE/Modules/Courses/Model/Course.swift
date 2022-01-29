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
                           Course(id: 4, title: "Onlyfans"),
                           Course(id: 5, title: "Algebra"),
                           Course(id: 6, title: "Time Series"),
                           Course(id: 7, title: "Econometrics"),
                           Course(id: 8, title: "Macchine Learning 1"),
                           Course(id: 9, title: "BAFE")
    ]
    
}


//temp things for layout

struct Chat: Hashable {
    
    let id = UUID()
    let name: String
    
    static let chats = [Chat(name: "random"),
                        Chat(name: "random2"),
                        Chat(name: "random3")]
}


struct TA: Hashable {
    let id = UUID()
    let name: String
    
    
    static let tas = [TA(name: "DIMA"),
                      TA(name: "Oleg"),
                      TA(name: "Dan")
    ]
}

struct Formula: Hashable {
    let id = UUID()
    let formula: String
    
    static let testItem = Formula(formula: "0.25*(0.3*Exam1 + 0.7*(0.3125*Oral1 + 0.25* W1 + 0.25*Q1 + 0.1875*H1)) +  0.75*(0.3*Exam2 + 0.7*(0.3125*Oral2 + 0.25*W2 + 0.25*Q2 +0.1875*H2)))")
}

struct Description: Hashable {
    let id = UUID()
    let description: String
    
    static let testItem = Description(description: "ssffssdsdsd")
}
