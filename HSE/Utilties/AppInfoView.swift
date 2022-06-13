//
//  AppInfoView.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.06.2022.
//

import UIKit
import HSESKIT

final class AppInfo: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.setWidth(to: 100)
        imageView.pinHeight(to: imageView.widthAnchor, 1)
        imageView.clipsToBounds = true

        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .customFont.style(.footnote)()
        label.textColor = .textAndIcons.style(.primary)()

        return label
    }()

    private let detailedLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .customFont.style(.special)()
        label.textColor = .textAndIcons.style(.secondary)()
        label.numberOfLines = 0

        return label
    }()

    // MARK: - Init
    init(logo: UIImage, _ title: String, _ details: String) {
        super.init(frame: .zero)

        imageView.image = logo
        titleLabel.text = title
        detailedLabel.text = details

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI setup
    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, detailedLabel])

        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 12

        self.addSubview(stackView)

        stackView.pin(to: self)
    }
}
