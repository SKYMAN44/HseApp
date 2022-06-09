//
//  CourseViewModel.swift
//  HSE
//
//  Created by Дмитрий Соколов on 12.01.2022.
//

import Foundation

// fake so far no real viewModel
class CourseViewModel {
    let title: String
    let counter: Int

    init(course: Course) {
        self.title = course.title
        let flag = Bool.random()
        counter = flag ? Int.random(in: 0...999) : 0
    }
}
