//
//  TaskDetailViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 28.01.2022.
//

import UIKit

struct DummyStruct: Hashable {
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
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private var sections = [Section]()
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    private lazy var viewModel = TaskViewModel(collectionView)
    
    init(deadline: Deadline) {
        super.init(nibName: nil, bundle: nil)
        
        collectionView.collectionViewLayout.invalidateLayout()
//        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = viewModel.task?.taskDescription.discription
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.backgroundColor = .background.style(.accent)()
        let backImage = UIImage(named: "chevronleft")
        self.navigationController?.navigationBar.tintColor = .textAndIcons.style(.primary)()
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationBar.backItem?.title = ""
        self.view.backgroundColor = .background.style(.accent)()
        
        collectionView.delegate = self
        setup()
    }
    
    // MARK: - UI setup
    private func setup() {
        view.addSubview(collectionView)
        
        collectionView.pin(to: view, [.bottom, .left, .right])
        collectionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
    }
    
    // MARK: - Generate Layout
//    private func generateLayout() -> UICollectionViewLayout {
//        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//
//            switch sectionIndex {
//
//            }
//
//        }
//    }

}

// MARK: - DataSource


// MARK: - CollectionView Delegate
extension TaskDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        guard (collectionView.cellForItem(at: indexPath) as? TaskCollectionViewCell) != nil else { return }
//        let path =  Bundle.main.path(forResource: "TestFile", ofType: ".pdf")!
//        let dc = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
//        dc.delegate = self
//        dc.presentPreview(animated: true)
    }
}

