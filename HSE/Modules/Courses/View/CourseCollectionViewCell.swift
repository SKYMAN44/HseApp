//
//  CourseCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 16.01.2022.
//

import UIKit

class CourseCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CourseCollectionViewCell"
    
    enum Section: Hashable {
        case chat
        case tStuff
    }
    
    enum SupplementaryViewKind {
        static let search = "search"
        static let description = "description"
        static let formula = "formula"
    }
    
    var sections = [Section]()
    
    var oneCourseCollectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        oneCourseCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: generateLayout())
        
        oneCourseCollectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: ChatCollectionViewCell.reuseIdentifier)
        oneCourseCollectionView.register(UINib(nibName: "ChatCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: ChatCollectionViewCell.reuseIdentifier)
        oneCourseCollectionView.register(TeachingStuffCollectionViewCell.self, forCellWithReuseIdentifier: TeachingStuffCollectionViewCell.reuseIdentifier)
        oneCourseCollectionView.register(UINib(nibName: "TeachingStuffCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: TeachingStuffCollectionViewCell.reuseIdentifier)
        
        oneCourseCollectionView.delegate = self
        
        addSubview(oneCourseCollectionView)
        
        oneCourseCollectionView.translatesAutoresizingMaskIntoConstraints = false
        oneCourseCollectionView.backgroundColor = .white
        
        let constraints = [
            oneCourseCollectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            oneCourseCollectionView.leftAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            oneCourseCollectionView.rightAnchor.constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor),
            oneCourseCollectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension CourseCollectionViewCell: UICollectionViewDelegate {
    
}


extension CourseCollectionViewCell {
    
    func configureDataSource() {
        // MARK: Data Source Initialization
        dataSource = .init(collectionView: oneCourseCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let section = self.sections[indexPath.section]
            switch section {
            case .chat:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCollectionViewCell.reuseIdentifier, for: indexPath) as! ChatCollectionViewCell
                
                return cell
            case .tStuff:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeachingStuffCollectionViewCell.reuseIdentifier, for: indexPath) as! TeachingStuffCollectionViewCell
                
                return cell
            }
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.chat, .tStuff])
        
        snapshot.appendItems(Chat.chats, toSection: .chat)
        snapshot.appendItems(TA.tas, toSection: .tStuff)
        
        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }
    
    
    
    
    
    
    private func generateLayout() -> UICollectionViewLayout
    {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection?  in
        
            let section = self.sections[sectionIndex]
            
            switch section {
            case .chat:
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: nil, bottom: nil)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(85))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
                
                section.orthogonalScrollingBehavior = .none
                
                return section
                
            case .tStuff:
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalHeight(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: .fixed(8), trailing: nil, bottom: nil)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(36), heightDimension: .estimated(36))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24)
                section.orthogonalScrollingBehavior = .none
                
                return section
            }
        }
        return layout
    }

}
