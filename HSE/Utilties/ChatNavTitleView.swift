//
//  ChatNavTitleView.swift
//  HSE
//
//  Created by Дмитрий Соколов on 24.05.2022.
//
import UIKit

final class ChatNavTitleView: UIView {
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let indicatorImage = UIImageView()
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth, .flexibleTopMargin]
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI setup
    private func setupView() {
        imageView.pinWidth(to: imageView.heightAnchor, 1)
        indicatorImage.contentMode = .scaleAspectFit
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, indicatorImage])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        self.addSubview(stackView)
        stackView.pin(to: self, [.left: 5, .right: 5, .top: 5, .bottom: 5])
    }
    
    private func setupImageView(image: UIImage) {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        
        imageView.image = image.circleMask
    }
    
    public func configure(_ image: UIImage, _ title: String, _ indicatorName: String) {
        setupImageView(image: image)
        titleLabel.text = title
        indicatorImage.image = UIImage(named: indicatorName)
    }
}
