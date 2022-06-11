//
//  CourseCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 16.01.2022.
//

import UIKit

protocol CourseCollectionVeiwCellDelegate: AnyObject {
    func chatSelected()
}

final class CourseCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "CourseCollectionViewCell"

    enum Section: Hashable {
        case chat
        case description
        case tStuff
        case formula
    }

    private var sections = [Section]()

    private var oneCourseCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .background.style(.firstLevel)()

        collectionView.register(
            CourseChatCollectionViewCell.self,
            forCellWithReuseIdentifier: CourseChatCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            DescriptionCollectionViewCell.self,
            forCellWithReuseIdentifier: DescriptionCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            TeachingStuffCollectionViewCell.self,
            forCellWithReuseIdentifier: TeachingStuffCollectionViewCell.reuseIdentifier
        )
        collectionView.register(
            FormulaCollectionViewCell.self,
            forCellWithReuseIdentifier: FormulaCollectionViewCell.reuseIdentifier
        )

        return collectionView
    }()

    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!

    public unowned var delegate: CourseCollectionVeiwCellDelegate?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupCollectionView()

        oneCourseCollectionView.delegate = self
        configureDataSource()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI setup
    private func setupCollectionView() {
        addSubview(oneCourseCollectionView)

        oneCourseCollectionView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            oneCourseCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            oneCourseCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            oneCourseCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            oneCourseCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - CollectionView Delegate
extension CourseCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard (collectionView.cellForItem(at: indexPath) as? CourseChatCollectionViewCell) != nil else { return }

        delegate?.chatSelected()
    }
}

// MARK: - Data Source Initialization
extension CourseCollectionViewCell {
    func configureDataSource() {
        dataSource = .init(
            collectionView: oneCourseCollectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in

                let section = self.sections[indexPath.section]
                switch section {
                case .chat:
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: CourseChatCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    )

                    return cell
                case .description:
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: DescriptionCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    )
                    if let cell = cell as? DescriptionCollectionViewCell {
                        cell.configure()
                    }

                    return cell
                case .tStuff:
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: TeachingStuffCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    )
                    if let cell = cell as? TeachingStuffCollectionViewCell {
                        cell.configure()
                    }

                    return cell
                case .formula:
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: FormulaCollectionViewCell.reuseIdentifier,
                        for: indexPath
                    )
                    if let cell = cell as? FormulaCollectionViewCell,
                       let item = item as? Formula {
                        cell.configure(item)
                    }

                    return cell
                }
            }
        )

        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.chat, .description, .tStuff, .formula])

        snapshot.appendItems(Chat.chats, toSection: .chat)
        snapshot.appendItems(TA.tas, toSection: .tStuff)
        snapshot.appendItems([Description.testItem], toSection: .description)
        snapshot.appendItems([Formula.testItem], toSection: .formula)

        sections = snapshot.sectionIdentifiers
        dataSource.apply(snapshot)
    }
}
