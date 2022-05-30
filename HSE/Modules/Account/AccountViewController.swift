//
//  AccountViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.01.2022.
//

import UIKit
import HSESKIT

final class AccountViewController: UIViewController {
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
        
        return collectionView
    }()
    private var viewModel: AccountViewModel?
    private var isMyAccount: Bool = false
    
    // MARK:  - Init
    init(userReference: UserReference? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        if let user = userReference {
            viewModel = AccountViewModel(collectionView, user)
            isMyAccount = false
        } else {
            viewModel = AccountViewModel(collectionView)
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
    }
    
    private func setupNavBar() {
        self.navigationController?.navigationBar.backgroundColor = .background.style(.accent)()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
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
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(150))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0)
            
            return section
        }
        return layout
    }
}
