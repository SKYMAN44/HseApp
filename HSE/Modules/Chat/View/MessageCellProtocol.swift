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
//    var delegate: chatCellDelegate {get set}
//    var myIndexPath: IndexPath {get set}
    
    func configure(message: MessageViewModel)
    func handleReply()
}


protocol chatCellDelegate {
    func selectedContentInCell(content: UIImageView, indexPath: IndexPath)
}
