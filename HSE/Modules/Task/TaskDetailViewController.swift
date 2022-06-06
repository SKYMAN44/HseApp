//
//  TaskDetailViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 28.01.2022.
//

import UIKit


final class TaskDetailViewController: UIViewController, TaskDetailModule {
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .textAndIcons.style(.primary)()
        button.addConstraint(NSLayoutConstraint(
            item: button,
            attribute: .height,
            relatedBy: .equal,
            toItem: button,
            attribute: .width,
            multiplier: 1,
            constant: 0
        ))
        button.setWidth(to: 36)
        button.layer.cornerRadius = 18
        button.layer.applySketchShadow(color: .black, alpha: 0.5, x: 0, y: 2, blur: 16, spread: 0)
        
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: -16)
        
        collectionView.register(TaskHeaderCollectionReusableView.self, forSupplementaryViewOfKind: self.headerKind, withReuseIdentifier: TaskHeaderCollectionReusableView.reuseIdentifier)
        collectionView.register(TaskInfoCollectionViewCell.self, forCellWithReuseIdentifier: TaskInfoCollectionViewCell.reusdeIdentifier)
        collectionView.register(TimeCollectionViewCell.self, forCellWithReuseIdentifier: TimeCollectionViewCell.reuseIdentifier)
        collectionView.register(CreatorCollectionViewCell.self, forCellWithReuseIdentifier: CreatorCollectionViewCell.reusdeIdentifier)
        collectionView.register(TaskCollectionViewCell.self, forCellWithReuseIdentifier: TaskCollectionViewCell.reuseIdentifier)
        collectionView.register(SubmissionCollectionViewCell.self, forCellWithReuseIdentifier: SubmissionCollectionViewCell.reuseIdentifier)
        collectionView.register(EditButtonCollectionViewCell.self, forCellWithReuseIdentifier: EditButtonCollectionViewCell.reuseIdentifier)
        collectionView.register(AddFileCollectionViewCell.self, forCellWithReuseIdentifier: AddFileCollectionViewCell.reuseIdentifier)
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    public let headerKind: String = "header"
    private var taskViewModel: TaskFeatureLogic?
    
    // MARK: - Init
    init(deadline: Deadline) {
        super.init(nibName: nil, bundle: nil)
        
        taskViewModel = TaskViewModel(self, collectionView, deadline: deadline)
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.backgroundColor = .background.style(.accent)()
        let backImage = UIImage(named: "chevronleft")
        self.navigationController?.navigationBar.tintColor = .textAndIcons.style(.primary)()
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationBar.backItem?.title = ""
        self.view.backgroundColor = .background.style(.accent)()
        
//        collectionView.delegate = self
        setup()
    }
    
    // MARK: - UI setup
    private func setup() {
        view.addSubview(collectionView)
        collectionView.pin(to: view, [.bottom, .left, .right])
        collectionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        
        view.addSubview(dismissButton)
        dismissButton.pin(to: view, [ .right: 20, .top: 20])
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Interactions
    @objc
    private func dismissButtonTapped() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Generate Layout
    private func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let viewModel = self.taskViewModel else {
                return nil
            }
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: self.headerKind, alignment: .top)
            
            switch viewModel.sections[sectionIndex] {
            case .taskInfo, .publicationTime, .deadlineTime, .creator, .submissionTime, .edit:
                return self.dynamicSectionGenerator()
            case .taskFiles, .submission:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(ScreenSize.Width - 32), heightDimension: .estimated(50))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: .none, top: .fixed(10), trailing: .none, bottom: .none)
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
                section.boundarySupplementaryItems = [header]
                
                return section
            }
        }
        return layout
    }
    
    private func dynamicSectionGenerator() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(ScreenSize.Width - 32), heightDimension: .estimated(50))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        
        return section
    }
}

//// MARK: - CollectionView Delegate
//extension TaskDetailViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
////        guard (collectionView.cellForItem(at: indexPath) as? TaskCollectionViewCell) != nil else { return }
////        let path =  Bundle.main.path(forResource: "TestFile", ofType: ".pdf")!
////        let dc = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
////        dc.delegate = self
////        dc.presentPreview(animated: true)
//    }
//}

