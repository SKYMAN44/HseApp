//
//  MessageCellFactory.swift
//  HSE
//
//  Created by Дмитрий Соколов on 31.01.2022.
//

import Foundation
import UIKit


struct MessageCellFactory {
    
    static public func createCell(message: MessageViewModel, tableView: UITableView, indexPath: IndexPath, hostingController: chatCellDelegate) -> MessageCellProtocol {
        switch message.side {
        case .left:
            switch message.type {
            case .text:
                let cell = tableView.dequeueReusableCell(withIdentifier: LeftTextMessageTableViewCell.reuseIdentifier, for: indexPath) as! LeftTextMessageTableViewCell
                cell.delegate = hostingController
                cell.myIndexPath = indexPath
                
                return cell
            case .image:
                let cell = tableView.dequeueReusableCell(withIdentifier: LeftImageMessageTableViewCell.reuseIdentifier, for: indexPath) as! LeftImageMessageTableViewCell
                cell.delegate = hostingController
                cell.myIndexPath = indexPath
                
                return cell
            }
        case .right:
            switch message.type {
            case .text:
                let cell = tableView.dequeueReusableCell(withIdentifier: RightTextMessageTableViewCell.reuseIdentifier, for: indexPath) as! RightTextMessageTableViewCell
                cell.delegate = hostingController
                cell.myIndexPath = indexPath
                
                return cell
            case .image:
                let cell = tableView.dequeueReusableCell(withIdentifier: RightImageMessageTableViewCell.reuseIdentifier, for: indexPath) as! RightImageMessageTableViewCell
                cell.delegate = hostingController
                cell.myIndexPath = indexPath
                
                return cell
            }
        }
    }
}
