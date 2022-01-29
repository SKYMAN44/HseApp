//
//  TableView.swift
//  HSE
//
//  Created by Дмитрий Соколов on 29.01.2022.
//

import Foundation
import UIKit

extension UITableView {

    func scrollToBottom(isAnimated: Bool = true) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.numberOfRows(inSection:  self.numberOfSections-1) - 1, section: self.numberOfSections - 1)
            self.scrollToRow(at: indexPath, at: .bottom, animated: isAnimated)
        }
    }
}
