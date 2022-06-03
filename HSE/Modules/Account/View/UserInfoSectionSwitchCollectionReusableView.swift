//
//  UserInfoSectionSwitchCollectionReusableView.swift
//  HSE
//
//  Created by Дмитрий Соколов on 31.05.2022.
//

import UIKit
import HSESKIT

// MARK: - Delegate
protocol UserInfoSectionSwitcherDelegate {
    func segmentHasChanged(_ segment: Int)
}

final class UserInfoSectionSwitchCollectionReusableView: UICollectionReusableView {
    static let reuseIdentifier = "UserInfoSectionSwitchCollectionReusableView"
    
    private let segmentTimeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .background.style(.firstLevel)()
        button.layer.cornerRadius = 8
        button.setTitle("Timetable", for: .normal)
        button.setTitleColor(.textAndIcons.style(.secondary)(), for: .normal)
        button.titleLabel?.font = .customFont.style(.body)()
        
        return button
    }()
    
    private let segmentInfoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .background.style(.firstLevel)()
        button.layer.cornerRadius = 8
        button.setTitle("Information", for: .normal)
        button.setTitleColor(.textAndIcons.style(.secondary)(), for: .normal)
        button.titleLabel?.font = .customFont.style(.body)()
        
        return button
    }()
    public var delegate: UserInfoSectionSwitcherDelegate?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupButtons()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setup UI
    private func setupUI() {
        self.backgroundColor = .background.style(.accent)()
        
        let stackView = UIStackView(arrangedSubviews: [segmentTimeButton, segmentInfoButton])
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 12
        
        self.addSubview(stackView)
        stackView.pin(to: self, [.left: 16, .right: 16, .top: 6, .bottom: 6])
        
        segmentSelected(segmentTimeButton)
    }
    
    private func setupButtons() {
        segmentTimeButton.tag = 0
        segmentInfoButton.tag = 1
        segmentTimeButton.addTarget(self, action: #selector(segmentSelected(_:)), for: .touchUpInside)
        segmentInfoButton.addTarget(self, action: #selector(segmentSelected(_:)), for: .touchUpInside)
    }

    // MARK: - Interactions
    @objc
    private func segmentSelected(_ button: UIButton) {
        if(button.tag == 0) {
            delegate?.segmentHasChanged(0)
            button.backgroundColor = .primary.style(.filler)()
            button.setTitleColor(.primary.style(.primary)(), for: .normal)
            segmentInfoButton.backgroundColor = .background.style(.firstLevel)()
            segmentInfoButton.setTitleColor(.textAndIcons.style(.secondary)(), for: .normal)
        } else {
            delegate?.segmentHasChanged(1)
            button.backgroundColor = .primary.style(.filler)()
            button.setTitleColor(.primary.style(.primary)(), for: .normal)
            segmentTimeButton.backgroundColor = .background.style(.firstLevel)()
            segmentTimeButton.setTitleColor(.textAndIcons.style(.secondary)(), for: .normal)
        }
    }
    
    // MARK: - External Calls
    public func setSelection() {
        
    }
}
