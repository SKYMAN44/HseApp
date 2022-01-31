//
//  MessageCellFactory.swift
//  HSE
//
//  Created by Дмитрий Соколов on 31.01.2022.
//

import Foundation
import UIKit


struct MessageCellFactory {
    
    static public func createCell(message: MessageViewModel, tableView: UITableView, indexPath: IndexPath) -> MessageCellProtocol {
        switch message.side {
        case .left:
            switch message.type {
            case .text:
                return tableView.dequeueReusableCell(withIdentifier: LeftTextMessageTableViewCell.reuseIdentifier, for: indexPath) as! LeftTextMessageTableViewCell
            case .image:
                return tableView.dequeueReusableCell(withIdentifier: LeftImageMessageTableViewCell.reuseIdentifier, for: indexPath) as! LeftImageMessageTableViewCell
            }
        case .right:
            switch message.type {
            case .text:
                return tableView.dequeueReusableCell(withIdentifier: RightTextMessageTableViewCell.reuseIdentifier, for: indexPath) as! MessageCellProtocol
            case .image:
                return tableView.dequeueReusableCell(withIdentifier: RightImageMessageTableViewCell.reuseIdentifier, for: indexPath) as! MessageCellProtocol
            }
        }
    }
}
