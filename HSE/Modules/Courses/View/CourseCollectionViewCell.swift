//
//  CourseCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 16.01.2022.
//

import UIKit

protocol CourseCollectionVeiwCellDelegate {
    func chatSelected()
}

//remake into tableview

final class CourseCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "CourseCollectionViewCell"
    
    enum Section: Hashable {
        case chat
        case tStuff
    }
    
    enum SupplementaryViewKind {
        static let search = "search"
        static let description = "description"
        static let formula = "formula"
        static let title = "title"
        static let formulaTitle = "formulaTitle"
    }
    
    private var sections = [Section]()
    
    private var oneCourseCollectionView: UICollectionView!
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    
    public var delegate: CourseCollectionVeiwCellDelegate?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        oneCourseCollectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        
        oneCourseCollectionView.register(CourseChatCollectionViewCell.self, forCellWithReuseIdentifier: CourseChatCollectionViewCell.reuseIdentifier)
        oneCourseCollectionView.register(TeachingStuffCollectionViewCell.self, forCellWithReuseIdentifier: TeachingStuffCollectionViewCell.reuseIdentifier)
        
        oneCourseCollectionView.register(DescriptionCollectionReusableView.self, forSupplementaryViewOfKind: SupplementaryViewKind.description, withReuseIdentifier: DescriptionCollectionReusableView.reuseIdentifier)
        oneCourseCollectionView.register(TitleCollectionReusableView.self, forSupplementaryViewOfKind: SupplementaryViewKind.title, withReuseIdentifier: TitleCollectionReusableView.reuseIdentifier)
        oneCourseCollectionView.register(TitleCollectionReusableView.self, forSupplementaryViewOfKind: SupplementaryViewKind.formulaTitle, withReuseIdentifier: TitleCollectionReusableView.reuseIdentifier)
        oneCourseCollectionView.register(FormulaCollectionReusableView.self, forSupplementaryViewOfKind: SupplementaryViewKind.formula, withReuseIdentifier: FormulaCollectionReusableView.reuseIdentifier)
        
        oneCourseCollectionView.delegate = self
        
        addSubview(oneCourseCollectionView)
        
        oneCourseCollectionView.translatesAutoresizingMaskIntoConstraints = false
        oneCourseCollectionView.backgroundColor = .background.style(.firstLevel)()
        
        let constraints = [
            oneCourseCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            oneCourseCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            oneCourseCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            oneCourseCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        configureDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension CourseCollectionViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard (collectionView.cellForItem(at: indexPath) as? CourseChatCollectionViewCell) != nil else { return }
        
        delegate?.chatSelected()
    }
}

extension CourseCollectionViewCell {
    
    func configureDataSource() {
        // MARK: Data Source Initialization
        
        dataSource = .init(collectionView: oneCourseCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let section = self.sections[indexPath.section]
            switch section {
            case .chat:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CourseChatCollectionViewCell.reuseIdentifier, for: indexPath) as! CourseChatCollectionViewCell
                
                return cell
            case .tStuff:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TeachingStuffCollectionViewCell.reuseIdentifier, for: indexPath) as! TeachingStuffCollectionViewCell
                cell.configure()
                
                return cell
            }
        })
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            switch kind {
            case SupplementaryViewKind.description:
                let descriptionView = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.description, withReuseIdentifier: DescriptionCollectionReusableView.reuseIdentifier, for: indexPath) as! DescriptionCollectionReusableView
                descriptionView.configure()
                
                return descriptionView
            case SupplementaryViewKind.title:
                let title = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.title, withReuseIdentifier: TitleCollectionReusableView.reuseIdentifier, for: indexPath) as! TitleCollectionReusableView
                title.setTitle(title: "Teaching Stuff")
                
                return title
            case SupplementaryViewKind.formulaTitle:
                let title = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.formulaTitle, withReuseIdentifier: TitleCollectionReusableView.reuseIdentifier, for: indexPath) as! TitleCollectionReusableView
                title.setTitle(title: "Formula")
                
                return title
            case SupplementaryViewKind.formula:
                let formula = collectionView.dequeueReusableSupplementaryView(ofKind: SupplementaryViewKind.formula, withReuseIdentifier: FormulaCollectionReusableView.reuseIdentifier, for: indexPath) as! FormulaCollectionReusableView
                
                formula.configure()
                
                return formula
            default:
                return nil
            }
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.chat, .tStuff])
        
        snapshot.appendItems(Chat.chats, toSection: .chat)
        snapshot.appendItems(TA.tas, toSection: .tStuff)
        
        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }
    
    
    
    
    // MARK: - Layout
    
    private func generateLayout() -> UICollectionViewLayout
    {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection?  in
            
            // is it the best approach ?
            let size = DescriptionCollectionReusableView(frame: .zero).systemLayoutSizeFitting(CGSize(width: self.frame.width, height: UIView.layoutFittingExpandedSize.height))
            let descriptionItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(size.height))
            let descriptionItem = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: descriptionItemSize, elementKind: SupplementaryViewKind.description, alignment: .bottom)
            
            let titleTA = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30)), elementKind: SupplementaryViewKind.title, alignment: .top)
            
            let titleFormula = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(30)), elementKind: SupplementaryViewKind.formulaTitle, alignment: .bottom)
            let formula = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2)), elementKind: SupplementaryViewKind.formula, alignment: .bottom)
            
            let section = self.sections[sectionIndex]
    
            switch section {
            case .chat:
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: nil, bottom: nil)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(85))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.boundarySupplementaryItems = [descriptionItem]
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                section.orthogonalScrollingBehavior = .none
                
                return section
                
            case .tStuff:
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(72))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.boundarySupplementaryItems = [titleTA, titleFormula, formula]
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                section.orthogonalScrollingBehavior = .none
                
                return section
            }
        }
        return layout
    }

}
