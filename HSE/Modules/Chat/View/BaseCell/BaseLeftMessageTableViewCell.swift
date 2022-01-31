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
        imageView.contentMode = .scaleAspectFill
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
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open func setupUI() {
        let mainSV = UIStackView(arrangedSubviews: [senderImage, bubbleView])
        mainSV.alignment = .top
        mainSV.distribution = .fill
        mainSV.axis = .horizontal
        mainSV.spacing = 8
        
        senderImage.translatesAutoresizingMaskIntoConstraints = false
        senderImage.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        addSubview(mainSV)
        
        mainSV.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainSV.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            mainSV.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            mainSV.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            mainSV.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor, constant: -100)
        ])
        bubbleView.backgroundColor = .background.style(.accent)()
    }

}

