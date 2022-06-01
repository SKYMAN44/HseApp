//
//  AccountViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.01.2022.
//

import UIKit
import HSESKIT

final class AccountViewController: UIViewController {
    public enum SupplementaryViewKind {
        static let segments = "segments"
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        collectionView.backgroundColor = .background.style(.firstLevel)()
        collectionView.register(
            AccountHeaderCollectionViewCell.self,
            forCellWithReuseIdentifier: AccountHeaderCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            HostingCollectionViewCell.self,
            forCellWithReuseIdentifier: HostingCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            UserInfoSectionSwitchCollectionReusableView.self,
            forSupplementaryViewOfKind: SupplementaryViewKind.segments,
            withReuseIdentifier: UserInfoSectionSwitchCollectionReusableView.reuseIdentifier
        )
        
        return collectionView
    }()
    private var viewModel: AccountViewModel?
    private var isMyAccount: Bool = false
    public var embededScrollView: UIScrollView?
    
    // MARK:  - Init
    init(userReference: UserReference? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        if let user = userReference {
            viewModel = AccountViewModel(collectionView, self, user)
            isMyAccount = false
        } else {
            viewModel = AccountViewModel(collectionView, self)
            isMyAccount = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - setup UI
    private func setupUI() {
        self.view.backgroundColor = .background.style(.accent)()
        setupNavBar()
        
        self.view.addSubview(collectionView)
        
        collectionView.pin(to: view, [.left, .right])
        collectionView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        collectionView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        collectionView.delegate = self
        collectionView.bounces = false
    }
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.backgroundColor = .background.style(.accent)()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        if(isMyAccount) {
            let settingsImage = UIImage(named: "SettingsIcon")?.withTintColor(.black)
            navigationItem.title = "Account"
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: settingsImage,
                style: .plain,
                target: self,
                action: #selector(showSettings)
            )
        }
    }
    
    // MARK: - Interactions
    @objc
    private func showSettings() {
        
    }
    
    
    
    // MARK: - Layout Creation
    private func generateLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let segmentsItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(48))
            let segmentItem = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: segmentsItemSize,
                elementKind: SupplementaryViewKind.segments,
                alignment: .top
            )
            segmentItem.pinToVisibleBounds = true
            
            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0)
                
                return section
            default:
                let valideHeight = self.view.frame.height - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom - 48
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(valideHeight))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(valideHeight))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                section.boundarySupplementaryItems = [segmentItem]
                
                return section
            }
        }
        return layout
    }
}

// MARK: - ScrollView Delegate
extension AccountViewController: UICollectionViewDelegate, TimeTableViewControllerScrollDelegate {
    func didScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        if(yOffset <= 0) {
            collectionView.isScrollEnabled = true
            embededScrollView?.isScrollEnabled = false
            embededScrollView?.resignFirstResponder()
            collectionView.becomeFirstResponder()
//            embededScrollView?.resignFirstResponder()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard embededScrollView != nil else { return }
        guard  let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 1)) else { return }
        let newRect = cell.frame
        let newRectAgain = collectionView.convert(newRect, to: collectionView.superview)
        if collectionView.frame.contains(newRectAgain) {
            embededScrollView?.isScrollEnabled = true
            collectionView.isScrollEnabled = false
            collectionView.resignFirstResponder()
            embededScrollView?.becomeFirstResponder()
//            collectionView.resignFirstResponder()
        }
    }
}
