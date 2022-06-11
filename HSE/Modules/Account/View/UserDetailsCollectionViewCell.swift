//
//  UserDetailsCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 02.06.2022.
//

import UIKit

final class UserDetailsCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "UserDetailsCollectionViewCell"
    
    private let testLabel = UILabel()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        self.addSubview(testLabel)
        testLabel.text = "TestLabel"
        testLabel.pinCenter(to: self)
    }
    
    // MARK: - Configuration
    public func configure() {}
}
