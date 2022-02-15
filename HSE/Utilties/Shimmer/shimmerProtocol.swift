//
//  shimmerProtocol.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.02.2022.
//

import Foundation
import UIKit

protocol ShimmeringObject {
    func startShimmer()
    func stopShimmer()
}

extension ShimmeringObject {
    func applyShimmerTo(to views: [UIView]) {
        for view in views {
            view.configureAndStartShimmering()
        }
    }
    
    func removeShimmerFrom(from views: [UIView]) {
        for view in views {
            view.stopShimmering()
        }
    }
}
