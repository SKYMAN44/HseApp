//
//  ShimmerScheduleTableViewCell.swift
//  HSE
//
//  Created by Дмитрий Соколов on 12.02.2022.
//

import UIKit

class ShimmerScheduleTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ShimmerScheduleTableViewCell"
    
    private var shimmerLayer: CALayer?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        shimmerLayer?.removeFromSuperlayer()
    }
    
    public func showLoading() {
        let light = UIColor(white: 0, alpha: 0.1).cgColor

        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, light, UIColor.clear.cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.525)
        gradient.locations = [0.4, 0.5, 0.6]

        gradient.frame = CGRect(x: -contentView.bounds.width, y: 0, width: contentView.bounds.width * 3, height: contentView.bounds.height)

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.1, 0.2]
        animation.toValue = [0.8, 0.9, 1.0]

        animation.repeatCount = .infinity
        animation.duration = 1.1
        animation.isRemovedOnCompletion = false

        gradient.add(animation, forKey: "shimmer")
        
        contentView.layer.addSublayer(gradient)
        
        shimmerLayer = gradient
    }

}
