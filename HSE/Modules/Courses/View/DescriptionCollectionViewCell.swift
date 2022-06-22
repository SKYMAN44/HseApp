//
//  DescriptionCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 29.01.2022.
//

import UIKit

class DescriptionCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "DescriptionCollectionViewCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textAndIcons.style(.primary)()
        label.font = .customFont.style(.body)()
        label.textAlignment = .left
        label.text = "Course description"

        return label
    }()

    private let botomTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textAndIcons.style(.primary)()
        label.font = .customFont.style(.body)()
        label.textAlignment = .left
        label.text = "Teaching Staff"

        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .textAndIcons.style(.secondary)()
        label.font = .customFont.style(.footnote)()
        label.numberOfLines = 0
        label.text = "The course introduces students to the elements of linear algebra and analytic geometry, provides the foundations for understanding some of the main concepts of modern mathematics. There is a strong emphasis in this course on complete proofs of almost all results. \n We will approach the subject from both a practical point of view (learning methods and acquiring computational skills relevant for problem solving) and a theoretical point of view (learning a more abstract and theoretical approach that focuses on achieving a deep understanding of the different abstract concepts). \n Topics covered include: matrix algebra, systems of linear equations, permutations, determinants, complex numbers, fields, abstract vector spaces, bilinear and quadratic forms, Euclidean spaces, some elements of analytic geometry, linear operators. It took mathematicians at least two hundred years to comprehend these objects. We plan to accomplish this in one year."

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        let mainSV = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, botomTitleLabel])
        mainSV.distribution = .fill
        mainSV.alignment = .leading
        mainSV.axis = .vertical
        mainSV.spacing = 12

        addSubview(mainSV)

        mainSV.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            mainSV.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainSV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            mainSV.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            mainSV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            mainSV.widthAnchor.constraint(equalToConstant: ScreenSize.Width - 32)
        ])
    }

    public func configure(_ desc: String) {
        descriptionLabel.text = desc
    }
}
