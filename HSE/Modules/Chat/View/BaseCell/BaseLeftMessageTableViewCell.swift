//
//  BaseMessageTableViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 31.01.2022.
//

import UIKit

open class BaseLeftMessageTableViewCell: UITableViewCell {
    public let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .background.style(.accent)()
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    public let senderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addConstraint(NSLayoutConstraint(item: imageView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: imageView,
                                                  attribute: .width,
                                                  multiplier: 1,
                                                  constant: 0))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "testPic.jpg")!.circleMask
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    unowned var delegate: ChatCellDelegate?
    var myIndexPath: IndexPath?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
        let interaction = UIContextMenuInteraction(delegate: self)
        bubbleView.addInteraction(interaction)
        let tap = UITapGestureRecognizer(target: self, action: #selector(userTapped))
        senderImage.addGestureRecognizer(tap)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UI setup
    open func setupUI() {
        let mainSV = UIStackView(arrangedSubviews: [senderImage, bubbleView])
        mainSV.alignment = .top
        mainSV.distribution = .fill
        mainSV.axis = .horizontal
        mainSV.spacing = 8
        
        senderImage.translatesAutoresizingMaskIntoConstraints = false
        senderImage.widthAnchor.constraint(equalToConstant: 36).isActive = true
        
        self.contentView.addSubview(mainSV)
        
        mainSV.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainSV.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            mainSV.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            mainSV.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8),
            mainSV.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -100)
        ])
        bubbleView.backgroundColor = .background.style(.accent)()
        
    }
    
    @objc
    private func userTapped() {
        delegate?.userSelected()
    }
}

extension BaseLeftMessageTableViewCell: UIContextMenuInteractionDelegate {
    public func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { _ in
            let children: [UIMenuElement] = [self.makeRemoveRatingAction()]
            return UIMenu(title: "", children: children)
        })
    }
    
    func makeRemoveRatingAction() -> UIAction {
        return UIAction(
        title: "Reply",
        image: UIImage(systemName: "arrowshape.turn.up.left"),
        identifier: nil,
        handler: replySelected)
    }
    
    func replySelected(from action: UIAction) { }
}

