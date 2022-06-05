//
//  AccountViewModel.swift
//  HSE
//
//  Created by Дмитрий Соколов on 28.05.2022.
//

import UIKit


final class AccountViewModel {
    private typealias CollectionDataSource = UICollectionViewDiffableDataSource<AnyHashable, Item>
    private typealias CollectionSnapshot = NSDiffableDataSourceSnapshot<AnyHashable, Item>
    
    private weak var viewController: UIViewController?
    private var timeTableModule: TimeTableModule?
    private let collectionView: UICollectionView
    private var user: User?
    private var userReference: UserReference?
    private var isLoading: Bool = false {
        didSet {
            if(isLoading) {
                setShimmer()
            }
        }
    }
    
    // MARK: - DataSource
    private lazy var dataSource: CollectionDataSource = {
        let dataSource: CollectionDataSource =
            .init(collectionView: collectionView) { [self]
                collectionView, indexPath, itemIdentifier in
                
                switch itemIdentifier {
                case .userHeader(let userInfo):
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: AccountHeaderCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    )
                    if let cell = cell as? AccountHeaderCollectionViewCell {
                        cell.configure(userInfo, userReference == nil ? false : true)
                    }
                    return cell
                case .content(let details):
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: UserDetailsCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    )
                    
                    return cell
                case .timetable(_):
                    guard let vc = self.viewController else { return nil }
                    
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: HostingCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    )
                    
                    self.timeTableModule = TimeTableViewController(true)
                    if let scrollView = timeTableModule?.setupForEmbedingInScrollView(),
                       let vc = vc as? AccountViewController,
                       let timeModule = timeTableModule {
                        vc.embededScrollView = scrollView
                        timeTableModule?.delegate = vc
                        vc.addChild(timeModule)
                        
                        if let cell = cell as? HostingCollectionViewCell {
                            cell.configure(view: timeModule.view)
                        }
                    }
                    
                    return cell
                default:
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: AccountHeaderCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    )
                    return cell
                }
            }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case AccountViewController.SupplementaryViewKind.segments:
                let segmentView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: AccountViewController.SupplementaryViewKind.segments,
                    withReuseIdentifier: UserInfoSectionSwitchCollectionReusableView.reuseIdentifier,
                    for: indexPath
                ) as? UserInfoSectionSwitchCollectionReusableView
                segmentView?.delegate = self
                return segmentView
            default:
                return nil
            }
        }
        return dataSource
    }()
    
    // MARK: - CollectionItem
    private enum Item: Hashable {
        case userHeader(UserGeneralInfo)
        case timetable(UUID)
        case content(UserDetailedInfo)
        case loading(UUID)
        
        static var loadingItems: [Item] {
            return Array(repeatingExpression: Item.loading(UUID()), count: 1)
        }
    }
    
    // MARK: - Init
    init(
        _ collectionView: UICollectionView,
        _ viewController: UIViewController,
        _ userReference: UserReference? = nil
    ) {
        self.viewController = viewController
        self.collectionView = collectionView
        collectionView.dataSource = dataSource
        self.userReference = userReference
        
        fetchUserInfo()
    }
    
    // MARK: - DataSource update
    private func updateDataSource() {
        guard let user = user else { return }
        var snapshot = CollectionSnapshot()
        
        snapshot.appendSections(["Header","Content"])
        snapshot.appendItems([Item.userHeader(user.userMainInfo)], toSection: "Header")
        if let details = user.detailInfo {
            snapshot.appendItems([Item.timetable(UUID()), Item.content(details)], toSection: "Content")
        }
        dataSource.apply(snapshot)
    }
    
    // MARK: - API CALL
    private func fetchUserInfo() {
        self.user = User.testUser
        updateDataSource()
    }
    
    // MARK: - Shimmer
    private func setShimmer() { }
}

// MARK: - UserInfoSectionSwitcher Delegate
extension AccountViewModel: UserInfoSectionSwitcherDelegate {
    func segmentHasChanged(_ segment: Int) {
//        guard let cell = collectionView.cellForItem(at: IndexPath(item: segment, section: 1)) else { return }
//        collectionView.
//        self.collectionView.scrollRectToVisible(cell.frame, animated: true)
//        collectionView.scrollToItem(at: IndexPath(item: segment, section: 1), at: .centeredHorizontally, animated: true)
//        self.collectionView.scrollToItem(at: IndexPath(item: segment, section: 1), at: .centeredHorizontally, animated: true)
    }
}
