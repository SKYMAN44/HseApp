//
//  CollectionView.swift
//  HSE
//
//  Created by Дмитрий Соколов on 29.01.2022.
//

import Foundation
import UIKit

extension UICollectionView {

    func deselectAllItems(animated: Bool) {
        guard let selectedItems = indexPathsForSelectedItems else { return }
        selectedItems.forEach({
            deselectItem(at: $0, animated: animated)
        })
    }
}
