//
//  CourseViewModel.swift
//  HSE
//
//  Created by Дмитрий Соколов on 20.06.2022.
//

import Foundation
import UIKit


final class CourseViewModel: NSObject, CoursePresentationLogic {
    private typealias CollectionDataSource = UICollectionViewDiffableDataSource<CourseSection, AnyHashable>

    private let networkManager: SubjectsNetworkManager
    private weak var collectionView: UICollectionView?
    private var dataSource: CollectionDataSource?
    private var sections = [CourseSection]()
    private let courseId: Int

    private var dataToPresent: CoursePresentationModel?
    private var course: CourseApiResponse? {
        didSet {
            processCourseData()
        }
    }

    // MARK: - Init
    init(
        _ courseId: Int,
        _ networkManager: SubjectsNetworkManager,
        _ collectionView: UICollectionView
    ) {
        self.networkManager = networkManager
        self.courseId = courseId
        self.collectionView = collectionView

        super.init()

        configureDataSource()
        collectionView.dataSource = dataSource

        fetchCourse()
    }

    // MARK: - Api calls
    private func fetchCourse() {
        networkManager.getCourseById(courseId) { (data, error) in
            if let error = error {
                print(error)
            } else if let data = data {
                self.course = data
            }
        }
    }

    func processCourseData() {
        guard let course = course else {
            return
        }

        self.dataToPresent = CoursePresentationModel(
            chat: Chat.chats,
            assitants: TA.tas,
            description: Description(description: course.courseDesc),
            formula: Formula.testItem
        )

        updateDataSource()
    }

    func updateDataSource() {
        guard let dataToPresent = dataToPresent else {
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<CourseSection, AnyHashable>()
        snapshot.appendSections([.chat, .description, .tStuff, .formula])

        snapshot.appendItems(dataToPresent.chat, toSection: .chat)
        snapshot.appendItems(dataToPresent.assitants, toSection: .tStuff)
        snapshot.appendItems([dataToPresent.description], toSection: .description)
        snapshot.appendItems([dataToPresent.formula], toSection: .formula)

        sections = snapshot.sectionIdentifiers
        dataSource?.apply(snapshot)
    }

    // MARK: - DataSource
    func configureDataSource() {
        dataSource = .init(
            collectionView: collectionView!,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in

                let section = self.sections[indexPath.section]
                switch section {
                case .chat:
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: CourseChatCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    )

                    return cell
                case .description:
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: DescriptionCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    )
                    if let cell = cell as? DescriptionCollectionViewCell,
                        let text = item as? Description {
                        cell.configure(text.description)
                    }

                    return cell
                case .tStuff:
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: TeachingStuffCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    )
                    if let cell = cell as? TeachingStuffCollectionViewCell {
                        cell.configure()
                    }

                    return cell
                case .formula:
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: FormulaCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    )
                    if let cell = cell as? FormulaCollectionViewCell,
                       let item = item as? Formula {
                        cell.configure(item)
                    }

                    return cell
                }
            }
        )
    }
}
