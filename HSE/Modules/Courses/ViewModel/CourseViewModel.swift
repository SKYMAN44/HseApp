//
//  CourseViewModel.swift
//  HSE
//
//  Created by Дмитрий Соколов on 12.01.2022.
//

import Foundation


class CourseViewModel {
    
    let title: String
    
    init(course: Course) {
        self.title = course.title
    }
}
