//
//  TimeTableFeatureProtocols.swift
//  HSE
//
//  Created by Дмитрий Соколов on 06.06.2022.
//

import UIKit

protocol TimeTableViewControllerScrollDelegate: AnyObject {
    func didScroll(_ scrollView: UIScrollView)
}

protocol TimeTableScreen: UIViewController {
    var delegate: TimeTableViewControllerScrollDelegate? { get set }
    
    func setupForEmbedingInScrollView() -> UIScrollView
    func contentChanged(contentType: ContentType)
    func deadlineContentChanged(_ deadlineType: DeadlineContentType)
}

protocol TimeTableFeatureLogic {
    init(
        _ viewController: TimeTableScreen,
        tableView: UITableView,
        _ deadlineNetworkManager: DeadlineNetworkManager,
        _ scheduleNetworkManager: ScheduleNetworkManager
    )
    
    func updateData()
    func contentChanged(contentType: ContentType)
    func deadLineContentChanged(_ type: DeadlineContentType)
}

internal enum ContentType {
    case timeTable
    case assigments
}

internal enum DeadlineContentType: String {
    case all
    case hw
    case cw
}
