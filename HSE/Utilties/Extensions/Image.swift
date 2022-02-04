//
//  ImageView.swift
//  HSE
//
//  Created by Дмитрий Соколов on 17.01.2022.
//

import Foundation
import UIKit

extension UIImage {
    
    var circleMask: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: .init(origin: .init(x: 0, y: 0), size: square))
        imageView.contentMode = .scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 0
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        defer { UIGraphicsEndImageContext() }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func clone() -> UIImage? {
        guard let originalCgImage = self.cgImage,
              let newCgImage = originalCgImage.copy()
        else {
            return nil
        }
        return UIImage(cgImage: newCgImage, scale: self.scale, orientation: self.imageOrientation)
    }
    
}
