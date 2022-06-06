//
//  TimeTableFeatureProtocols.swift
//  HSE
//
//  Created by Дмитрий Соколов on 06.06.2022.
//

import UIKit

protocol TimeTableViewControllerScrollDelegate {
    func didScroll(_ scrollView: UIScrollView)
}


protocol TimeTableModule: UIViewController {
    var delegate: TimeTableViewControllerScrollDelegate?  { get set }
    
    func setupForEmbedingInScrollView() -> UIScrollView
    func contentChanged(contentType: ContentType)
    func deadlineContentChanged(_ deadlineType: DeadlineContentType)
}


protocol TimeTableFeatureLogic {
    init(_ viewController: TimeTableModule, tableView: UITableView, _ networkManager: NetworkManager)
    
    func updateData()
    func contentChanged(contentType: ContentType)
    func deadLineContentChanged(_ type: DeadlineContentType)
}
