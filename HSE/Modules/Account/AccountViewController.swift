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
    
    private enum Consts {
        static let switcherHeight = 48.0
        static let topInset = 16.0
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
            UserDetailsCollectionViewCell.self,
            forCellWithReuseIdentifier: UserDetailsCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            UserInfoSectionSwitchCollectionReusableView.self,
            forSupplementaryViewOfKind: SupplementaryViewKind.segments,
            withReuseIdentifier: UserInfoSectionSwitchCollectionReusableView.reuseIdentifier
        )
        collectionView.showsVerticalScrollIndicator = false
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        collectionView.contentInsetAdjustmentBehavior = .never
        
        return collectionView
    }()
    private var viewModel: AccountViewModel?
    private var isMyAccount: Bool = false
    public weak var embededScrollView: UIScrollView?
    
    // MARK: - Init
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
        collectionView.pinBottom(to: isMyAccount ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor)
        collectionView.delegate = self
//        collectionView.bounces = false
    }
    
    // MARK: - setup NavBar
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
        } else {
            let leftBarButton = UIBarButtonItem(
                image: UIImage(named: "chevronleft"),
                style: .plain,
                target: self,
                action: #selector(goBack)
            )
            leftBarButton.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            navigationItem.leftBarButtonItem = leftBarButton
        }
    }
    
    // MARK: - Interactions
    @objc
    private func showSettings() {
        let settingsController = SettingsViewController()
        self.navigationController?.present(settingsController, animated: true)
    }
    
    @objc
    private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Layout Creation
    private func generateLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let segmentsItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(Consts.switcherHeight))
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
                section.contentInsets = NSDirectionalEdgeInsets(top: Consts.topInset, leading: 0, bottom: 0, trailing: 0)
                
                return section
            default:
                let valideHeight = self.collectionView.frame.height - Consts.switcherHeight
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(valideHeight))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(valideHeight))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item,item])

                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                section.boundarySupplementaryItems = [segmentItem]
                section.orthogonalScrollingBehavior = .paging
                
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
        } else {
            embededScrollView?.isScrollEnabled = true
            collectionView.isScrollEnabled = false
            collectionView.resignFirstResponder()
            embededScrollView?.becomeFirstResponder()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard embededScrollView != nil else { return }
        guard  let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 1)) else { return }
        let newRect = cell.frame
        let newRectAgain = collectionView.convert(newRect, to: collectionView.superview)
        print(scrollView.contentOffset.y)
        if collectionView.frame.contains(newRectAgain) {
            embededScrollView?.isScrollEnabled = true
            collectionView.isScrollEnabled = false
            collectionView.resignFirstResponder()
            embededScrollView?.becomeFirstResponder()
        }
    }
}
