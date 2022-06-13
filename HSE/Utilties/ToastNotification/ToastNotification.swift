//
//  ToastNotification.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.06.2022.
//

import UIKit

final class ToastNotification: UIView {
    static let successIcon = UIImage(named: "bookmark")
    static let failureIcon = UIImage(named: "alert-triangle")

    enum Consts {
        static let yAnimationOffset: CGFloat = 50
        static let padding: Double = 12.0
        static let screenPadding: CGFloat = 16.0
        static let imageWidth: Double = 24
        static let viewHeight = 48
    }

    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.setWidth(to: Consts.imageWidth)
        imageView.pinHeight(to: imageView.widthAnchor, 1)
        imageView.tintColor = .primary.style(.onPrimary)()

        return imageView
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primary.style(.onPrimary)()
        label.font = .customFont.style(.body)()

        return label
    }()

    // MARK: - Init
    init() {
        super.init(frame: CGRect(
            x: Int(Consts.screenPadding),
            y: 0,
            width: Int(ScreenSize.Width - Consts.screenPadding * 2),
            height: Consts.viewHeight)
        )

        self.layer.cornerRadius = 8
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - setupUI
    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [iconView, messageLabel])

        self.addSubview(stackView)
        stackView.pin(to: self, [
            .left: Consts.padding,
            .right: Consts.padding,
            .bottom: 12,
            .top: 12
        ])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 8
    }

    // MARK: - Animation
    private func showHideAnimation() {
        // get reference to root window
        guard let scontroller = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        else {
            return
        }
        scontroller.addSubview(self)
        self.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
            let translateTransform = CGAffineTransform(translationX: 0, y: Consts.yAnimationOffset)
            self.transform = translateTransform
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 2, animations: {
                self.transform = .identity
                self.alpha = 1
            }) { _ in
                self.removeFromSuperview()
            }
        }
    }

    // MARK: - External calls
    public func showSuccess(message: String) {
        iconView.image = Self.successIcon
        self.backgroundColor = .primary.style(.primary)()
        self.messageLabel.text = message

        showHideAnimation()
    }

    public func showFailure(message: String) {
        iconView.image = Self.failureIcon
        self.backgroundColor = .special.style(.warning)()
        self.messageLabel.text = message

        showHideAnimation()
    }
}
