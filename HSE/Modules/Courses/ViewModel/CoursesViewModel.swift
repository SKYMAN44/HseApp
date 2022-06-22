//
//  CourseViewModel.swift
//  HSE
//
//  Created by Дмитрий Соколов on 12.01.2022.
//

import Foundation
import UIKit

final class CoursesViewModel: NSObject, CoursesModuleLogic {
    private typealias CollectionDataSource = UICollectionViewDiffableDataSource<AnyHashable, AnyHashable>

    private var courseList: CourseList? {
        didSet {
            if let courseList = courseList {
                courseScreen?.setSegments(content: courseList.map({ item in
                    return (item.courseName, 0)
                }))
            }
        }
    }
    private var courseNetworkManager: SubjectsNetworkManager?
    private weak var courseScreen: CoursesModuleScreen?

    // MARK: - Init
    init(
        _ networkManager: SubjectsNetworkManager,
        _ courseScreen: CoursesModuleScreen,
        _ collectionView: UICollectionView
    ) {
        self.courseNetworkManager = networkManager
        self.courseScreen = courseScreen
        super.init()

        collectionView.dataSource = self
        fetchCourseList()
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

// MARK: - CollectionView DataSource
extension CoursesViewModel: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return courseList?.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CourseCollectionViewCell.reuseIdentifier,
            for: indexPath
         )

        if let cell = cell as? CourseCollectionViewCell,
            let courseList = courseList {
            cell.injectDependencies(CourseNetworkManager(), courseList[indexPath.row].id)
            cell.delegate = self
        }

        return cell
    }
}

// MARK: - CourseCellDelegate + Navigation
extension CoursesViewModel: CourseCollectionVeiwCellDelegate {
    func chatSelected() {
        let chatViewController = ChatViewController()

        courseScreen?.hidesBottomBarWhenPushed = true
        courseScreen?.navigationController?.pushViewController(chatViewController, animated: true)
        courseScreen?.hidesBottomBarWhenPushed = false
    }
}
