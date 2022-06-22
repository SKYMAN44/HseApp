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

    public unowned var delegate: CourseCollectionVeiwCellDelegate?
    private var viewModel: CoursePresentationLogic?

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupCollectionView()

        oneCourseCollectionView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Dependency injections
    public func injectDependencies(_ network: SubjectsNetworkManager, _ courseId: Int) {
        viewModel = CourseViewModel(courseId, network, oneCourseCollectionView)
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
