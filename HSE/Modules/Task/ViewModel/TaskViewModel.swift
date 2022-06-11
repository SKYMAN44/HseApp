//
//  TaskViewModel.swift
//  HSE
//
//  Created by Дмитрий Соколов on 07.02.2022.
//

import Foundation
import UIKit

final class TaskViewModel: TaskFeatureLogic {
    typealias CollectionDataSource = UICollectionViewDiffableDataSource<TaskSection, AnyHashable>
    typealias CollectionSnapshot = NSDiffableDataSourceSnapshot<TaskSection, AnyHashable>
    
    struct ReadyToViewModel {
        let taskDescription: TaskDescription
        let publicationTime: String
        let deadlineTime: String
        let taskFiles: [File]
        let postedBy: UserReference
        var submissionFiles: [SubmissionFile]
        var submissionTime: [String]
        
        enum SubmissionFile: Hashable {
            case normal(File)
            case editing(File)
            case addFile(UUID)
        }
    }
    
    private var collectionView: UICollectionView
    private var deadlineNetworkManager: DeadlineNetworkManager?
    private var deadline: Deadline
    private var editMode: Bool = false {
        didSet {
            updateDataSource()
        }
    }
    public var task: StudentTask = StudentTask.example {
        didSet {
            viewController.title = task.taskDescription.discription
            updateDataSource()
        }
    }
    
    private var viewController: TaskDetailScreen
    private var readyToViewTask: ReadyToViewModel?
    public var sections = [TaskSection]()
    
    // MARK: - DataSource
    private lazy var dataSource: CollectionDataSource = {
        let dataSource: CollectionDataSource = .init(collectionView: collectionView) { [self]
            collectionView, indexPath, item in
            
            let section = self.sections[indexPath.section]
            
            switch section {
            case .taskInfo:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TaskInfoCollectionViewCell.reusdeIdentifier,
                    for: indexPath
                ) as? TaskInfoCollectionViewCell
                
                return cell
            case .publicationTime, .deadlineTime, .submissionTime:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TimeCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? TimeCollectionViewCell
                cell?.configure(title: section.rawValue)
                
                return cell
            case .taskFiles:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TaskCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? TaskCollectionViewCell
                cell?.configure(file: task.taskFiles[indexPath.row])
                
                return cell
            case .creator:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: CreatorCollectionViewCell.reusdeIdentifier,
                    for: indexPath
                ) as? CreatorCollectionViewCell
                cell?.configure()
                
                return cell
            case .submission:
                let item = readyToViewTask?.submissionFiles[indexPath.row]
                if case let .addFile(id) = item {
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: AddFileCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    ) as? AddFileCollectionViewCell
                    
                    return cell
                }
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SubmissionCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? SubmissionCollectionViewCell
                if case let .editing(file) = item {
                    cell?.configure(file: file, isEditing: self.editMode)
                }
                if case let .normal(file) = item {
                    cell?.configure(file: file, isEditing: self.editMode)
                }
                return cell
            case .edit:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: EditButtonCollectionViewCell.reuseIdentifier,
                    for: indexPath
                ) as? EditButtonCollectionViewCell
                cell?.delegate = self
                cell?.configure(isEditing: self.editMode)
                
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, _, indexPath -> UICollectionReusableView? in
            let section = self.sections[indexPath.section]
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: self.viewController.headerKind,
                withReuseIdentifier: TaskHeaderCollectionReusableView.reuseIdentifier,
                for: indexPath
            ) as? TaskHeaderCollectionReusableView
            if case .taskFiles = section {
                headerView?.configure(title: "TASK FILES")
            } else {
                headerView?.configure(title: "SUBMISSION")
            }
            
            return headerView
        }
        return dataSource
    }()

    // MARK: - Init
    init(
        _ viewController: TaskDetailScreen,
        _ collectionView: UICollectionView,
        _ deadlineNetwork: DeadlineNetworkManager,
        deadline: Deadline
    ) {
        self.deadlineNetworkManager = deadlineNetwork
        self.viewController = viewController
        self.deadline = deadline
        self.collectionView = collectionView
        collectionView.dataSource = self.dataSource
        
        updateData()
    }
    
    // MARK: - DataSource update
    private func updateDataSource() {
        prepareData()
        var snapshot = CollectionSnapshot()
        
        snapshot.appendSections([
            .taskInfo,
            .publicationTime,
            .deadlineTime,
            .taskFiles,
            .creator,
            .submission,
            .submissionTime,
            .edit
        ])
        snapshot.appendItems([readyToViewTask?.taskDescription], toSection: .taskInfo)
        snapshot.appendItems([readyToViewTask?.publicationTime], toSection: .publicationTime)
        snapshot.appendItems([readyToViewTask?.deadlineTime], toSection: .deadlineTime)
        // remove !
        snapshot.appendItems(readyToViewTask?.taskFiles ?? [], toSection: .taskFiles)
        snapshot.appendItems([readyToViewTask?.postedBy], toSection: .creator)
        snapshot.appendItems(readyToViewTask?.submissionFiles ?? [], toSection: .submission)
        snapshot.appendItems(readyToViewTask?.submissionTime ?? [], toSection: .submissionTime)
        snapshot.appendItems([UUID()], toSection: .edit)
        
        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
        let lastSection = dataSource.numberOfSections(in: collectionView) - 1
        let lastIndexPath = IndexPath(row: 0, section: lastSection) // last section always consist of one item
        if let cell = collectionView.cellForItem(at: lastIndexPath) {
            collectionView.scrollRectToVisible(cell.frame, animated: true)
        }
    }
    
    private func prepareData() {
        var submissionFiles = [ReadyToViewModel.SubmissionFile]()
        if(editMode) {
            submissionFiles = task.submissionFiles.map { (item) in
                ReadyToViewModel.SubmissionFile.editing(item)
            }
            submissionFiles.insert(ReadyToViewModel.SubmissionFile.addFile(UUID()), at: 0)
        } else {
            submissionFiles = task.submissionFiles.map {(item) in
                ReadyToViewModel.SubmissionFile.normal(item)
            }
        }
        let viewModel = ReadyToViewModel(
            taskDescription: task.taskDescription,
            publicationTime: task.publicationTime,
            deadlineTime: task.deadlineTime,
            taskFiles: task.taskFiles,
            postedBy: task.postedBy,
            submissionFiles: submissionFiles,
            submissionTime: task.submissionTime != nil ? [task.submissionTime!] : []
        )
        
        self.readyToViewTask = viewModel
    }
    
    // MARK: - Network Call
    private func fetchTask() {
        // fake so far no backend(
        let studentTask = StudentTask(
            taskDescription: TaskDescription(courseName: "Mac", name: "s", discription: "a"),
            publicationTime: "ss",
            deadlineTime: "1234",
            taskFiles: [
                File(name: "SomeName"),
                File(name: "HW14: UOL harderst ARIMA tasks")
            ],
            postedBy: UserReference(id: 0, name: "s", image: nil),
            submissionFiles: [File(name: "Sokolov_Dmitrii_193_hw9_solutions.pdf")],
            submissionTime: "123"
        )
        self.task = studentTask
    }
    
    // MARK: - InternalCall
    private func updateData() {
        fetchTask()
    }
}

// MARK: - EditButtonDelegate
extension TaskViewModel: EditButtonDelegate {
    func editModeSwitched() {
        self.editMode.toggle()
    }
}
