//
//  IconTextInfoView.swift
//  HSE
//
//  Created by Дмитрий Соколов on 30.05.2022.
//
import UIKit
import HSESKIT

final class IconTextInfoView: UIView {
    private let icon: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addConstraint(NSLayoutConstraint(item: imageView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: imageView,
                                                  attribute: .width,
                                                  multiplier: 1,
                                                  constant: 0))
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    private let infoText: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .customFont.footnote.style()
        label.textColor = .textAndIcons.style(.primary)()
        
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [icon, infoText])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 11
        
        addSubview(stackView)
        stackView.pin(to: self, [.left: 0, .right: 0, .top: 14, .bottom: 14])
    }
    
    public func configure(icon: UIImage?, text: String) {
        if let icon = icon {
            self.icon.image = icon
        }
        self.infoText.text = text
    }
}
