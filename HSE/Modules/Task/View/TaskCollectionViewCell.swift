//
//  TaskCollectionViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 07.02.2022.
//

import UIKit

final class TaskCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "TaskCollectionViewCell"
    
    private let taskFileName: UILabel = {
        let label = UILabel()
        label.font = .customFont.style(.body)()
        label.textColor = .primary.style(.primary)()
        
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
        backgroundColor = .primary.style(.filler)()
        layer.cornerRadius = 8
        
        addSubview(taskFileName)
        
        taskFileName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskFileName.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            taskFileName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            taskFileName.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
        ])
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: ScreenSize.Width - 32).isActive = true
    }
    
    public func configure(file: File) {
        taskFileName.text = file.name
    }
}
