//
//  TaskDetailViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 28.01.2022.
//

import UIKit

struct dummyStruct: Hashable {
    let dummy = "dummy"
}

class TaskDetailViewController: UIViewController {
    
    enum Section: Hashable {
        case taskInfo
        case timeDetails
        case taskFile
        case taskCreator
        case submissions
        case submissionTime
        case submissionButton
    }
    
    enum SupplementaryViewKind {
        static let header = "header"
    }
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: -16)
        
        collectionView.register(TaskHeaderCollectionReusableView.self, forSupplementaryViewOfKind: SupplementaryViewKind.header , withReuseIdentifier: TaskHeaderCollectionReusableView.reuseIdentifier)
        collectionView.register(TaskInfoCollectionViewCell.self, forCellWithReuseIdentifier: TaskInfoCollectionViewCell.reusdeIdentifier)
        collectionView.register(TimeCollectionViewCell.self, forCellWithReuseIdentifier: TimeCollectionViewCell.reuseIdentifier)
        collectionView.register(CreatorCollectionViewCell.self, forCellWithReuseIdentifier: CreatorCollectionViewCell.reusdeIdentifier)
        collectionView.register(TaskCollectionViewCell.self, forCellWithReuseIdentifier: TaskCollectionViewCell.reuseIdentifier)
        collectionView.register(SubmitInteractionCollectionViewCell.self, forCellWithReuseIdentifier: SubmitInteractionCollectionViewCell.reuseIdentifier)
        collectionView.register(SubmissionCollectionViewCell.self, forCellWithReuseIdentifier: SubmissionCollectionViewCell.reusdeIdentifier)
        collectionView.register(AddSubmissionCollectionViewCell.self, forCellWithReuseIdentifier: AddSubmissionCollectionViewCell.reusdeIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private var sections = [Section]()
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    private let task: TaskViewModel
    private var isEditingFiles: Bool = false {
        didSet {
            let section = dataSource.snapshot(for: .submissions)
            var indexPaths: [IndexPath] = []
            section.items.forEach({ (item) in
                indexPaths.append(dataSource.indexPath(for: item)!)
            })
            indexPaths.forEach({
                if let cell = collectionView.cellForItem(at: $0) as? SubmissionCollectionViewCell {
                    cell.changeState(isEditing: isEditingFiles)
                }
            })
        }
    }
    
    init(deadline: Deadline) {
        self.task = TaskViewModel()
        super.init(nibName: nil, bundle: nil)
        
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.setCollectionViewLayout(generateLayout()
                                               , animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = task.description.taskName
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.backgroundColor = .background.style(.accent)()
        let backImage = UIImage(named: "chevronleft")
        self.navigationController?.navigationBar.tintColor = .textAndIcons.style(.primary)()
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationBar.backItem?.title = ""
        self.view.backgroundColor = .background.style(.accent)()
        
        collectionView.delegate = self
        configureDataSource()
        setup()
    }
    
    // MARK: - UI setup

    
    private func setup() {
        view.addSubview(collectionView)
        
        collectionView.pin(to: view, [.bottom, .left, .right])
        collectionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
    }

}

// MARK: - DataSource

extension TaskDetailViewController {
    func configureDataSource() {
    
        dataSource = .init(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            let section = self.sections[indexPath.section]
            switch section {
            case .taskInfo:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskInfoCollectionViewCell.reusdeIdentifier, for: indexPath) as! TaskInfoCollectionViewCell
                cell.configure()
                
                return cell
            case .timeDetails:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeCollectionViewCell.reuseIdentifier, for: indexPath) as! TimeCollectionViewCell
                if(indexPath.row == 0) {
                    cell.configure(title: "PUBLICATION TIME")
                } else {
                    cell.configure(title: "DEADLINE TIME")
                }
                
                return cell
            case .taskFile:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskCollectionViewCell.reuseIdentifier, for: indexPath) as! TaskCollectionViewCell
                let file = item as! File
                cell.configure(file: file)
                
                return cell
            case .taskCreator:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CreatorCollectionViewCell.reusdeIdentifier, for: indexPath) as! CreatorCollectionViewCell
                cell.configure()
                
                return cell
            case .submissions:
                if(indexPath.row > 0) {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubmissionCollectionViewCell.reusdeIdentifier, for: indexPath) as! SubmissionCollectionViewCell
                    let file = item as! File
                    cell.configure(file: file)
                    
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddSubmissionCollectionViewCell.reusdeIdentifier, for: indexPath) as! AddSubmissionCollectionViewCell
                    return cell
                }
            case .submissionTime:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimeCollectionViewCell.reuseIdentifier, for: indexPath) as! TimeCollectionViewCell
                cell.configure(title: "SUBMISSION TIME")
                
                return cell
            case .submissionButton:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubmitInteractionCollectionViewCell.reuseIdentifier, for: indexPath) as! SubmitInteractionCollectionViewCell
                cell.delegate = self
                
                return cell
            }
        })
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            if (kind == SupplementaryViewKind.header) {
                var title = ""
                switch indexPath.section {
                case 2:
                    title = "TASK FILES"
                case 4:
                    title = "SUBMISSIONS"
                default:
                    title = ""
                }
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.header, withReuseIdentifier: TaskHeaderCollectionReusableView.reuseIdentifier, for: indexPath) as! TaskHeaderCollectionReusableView
                headerView.configure(title: title)
                
                return headerView
            } else {
                return nil
            }
            
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.taskInfo, .timeDetails, .taskFile, .taskCreator,
                                    .submissions, .submissionTime, .submissionButton])
        
        snapshot.appendItems([task.description], toSection: .taskInfo)
        snapshot.appendItems([task.publication, task.deadLine], toSection: .timeDetails)
        snapshot.appendItems(task.taskFiles, toSection: .taskFile)
        snapshot.appendItems([task.creator], toSection: .taskCreator)
        snapshot.appendItems(task.submissionFiles, toSection: .submissions)
        snapshot.appendItems([task.submission], toSection: .submissionTime)
        snapshot.appendItems([dummyStruct()], toSection: .submissionButton)
        
        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }
    
    // MARK: - Layout
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let headerItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(44))
            let headerItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerItemSize, elementKind: SupplementaryViewKind.header , alignment: .top)
            
            let section = self.sections[sectionIndex]
            switch section {
            case .taskInfo:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(ScreenSize.Width - 32), heightDimension: .estimated(50))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
                
                return section
            case .timeDetails:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(ScreenSize.Width - 32), heightDimension: .estimated(50))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
                item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .none, top: .fixed(10), trailing: .none, bottom: .fixed(10))
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item, item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
                
                return section
            case .taskFile:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(ScreenSize.Width - 32), heightDimension: .estimated(50))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
                item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .none, top: .fixed(10), trailing: .none, bottom: .fixed(10))
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
                section.boundarySupplementaryItems = [headerItem]
                
                return section
            case .taskCreator:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(ScreenSize.Width - 32), heightDimension: .estimated(50))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
                item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .none, top: .fixed(10), trailing: .none, bottom: .fixed(10))
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
                
                return section
            case .submissions:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(ScreenSize.Width - 32), heightDimension: .estimated(0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0)
                item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .none, top: .fixed(10), trailing: .none, bottom: .fixed(10))
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(0))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
                section.boundarySupplementaryItems = [headerItem]
                
                return section
            case .submissionTime:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(ScreenSize.Width - 32), heightDimension: .estimated(50))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
                item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .none, top: .fixed(10), trailing: .none, bottom: .fixed(10))
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
                
                return section
            case .submissionButton:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(ScreenSize.Width - 32), heightDimension: .estimated(0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
                item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .none, top: .fixed(10), trailing: .none, bottom: .fixed(10))
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(0))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
                
                return section
            }
        }
        return layout
    }
}


// MARK: - CollectionView Delegate

extension TaskDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard (collectionView.cellForItem(at: indexPath) as? TaskCollectionViewCell) != nil else { return }
        let path =  Bundle.main.path(forResource: "TestFile", ofType: ".pdf")!
        let dc = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
        dc.delegate = self
        dc.presentPreview(animated: true)
    }
}

extension TaskDetailViewController: SubmitInteractionCollectionViewCellDelegate {
    func changeState() {
        self.isEditingFiles.toggle()
    }
    
}

// MARK: - DocumentInteractionDelegate
extension TaskDetailViewController:  UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self//or use return self.navigationController for fetching app navigation bar colour
    }
}

