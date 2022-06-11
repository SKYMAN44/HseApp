//
//  BaseRightMessageTableViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 31.01.2022.
//

import UIKit

open class BaseRightMessageTableViewCell: UITableViewCell {
    public let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.backgroundColor = .primary.style(.filler)()
        
        return view
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        let interaction = UIContextMenuInteraction(delegate: self)
        bubbleView.addInteraction(interaction)
    }

    unowned var delegate: ChatCellDelegate?
    var myIndexPath: IndexPath?

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI setup
    open func setupUI() {
        contentView.addSubview(bubbleView)
        
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bubbleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            bubbleView.leftAnchor.constraint(greaterThanOrEqualTo: contentView.leftAnchor, constant: 100)
        ])
    }
}

extension BaseRightMessageTableViewCell: UIContextMenuInteractionDelegate {
    public func contextMenuInteraction(
        _ interaction: UIContextMenuInteraction,
        configurationForMenuAtLocation location: CGPoint
    ) -> UIContextMenuConfiguration? {
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
            handler: replySelected
        )
    }
    
    func replySelected(from action: UIAction) { }
}
