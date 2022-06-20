//
//  CourseViewModel.swift
//  HSE
//
//  Created by Дмитрий Соколов on 12.01.2022.
//

import Foundation
import UIKit

// fake so far no real viewModel no backend(((((
class CourseViewModel {
    let title: String
    let counter: Int

    init(course: Course) {
        self.title = course.title
        let flag = Bool.random()
        counter = flag ? Int.random(in: 0...999) : 0
    }
}

final class CourseViewModell {
    private typealias CollectionDataSource = UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>

    private var courseList: CourseList? {
        didSet {

        }
    }
    private var courseNetworkManager: SubjectsNetworkManager?
    private weak var courseScreen: CoursesViewController?

    // MARK: - Init
    init(
        _ networkManager: SubjectsNetworkManager,
        _ courseScreen: CoursesViewController
    ) {
        self.courseNetworkManager = networkManager
        self.courseScreen = courseScreen
    }

    // MARK: - Data fetching
    private func fetchCourseList() {
        courseNetworkManager?.getCoursesList() { list, error in
            if let error = error {
                print(error)
            } else {
                self.courseList = list?.courses
            }
        }
    }
}
