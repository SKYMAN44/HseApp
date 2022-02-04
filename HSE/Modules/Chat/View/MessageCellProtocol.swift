//
//  MessageCellProtocol.swift
//  HSE
//
//  Created by Дмитрий Соколов on 31.01.2022.
//

import Foundation
import UIKit

protocol MessageCellProtocol: UITableViewCell {
    static var reuseIdentifier: String { get }
    
    func configure(message: MessageViewModel)
    func handleReply()
}

protocol ChatCellDelegate {
    func selectedContentInCell(content: UIImageView, indexPath: IndexPath)
}