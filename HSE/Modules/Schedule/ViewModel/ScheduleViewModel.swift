//
//  ScheduleDayViewModel.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation
import UIKit


enum ContentType {
    case timeTable
    case assigments
}

enum DeadlineContentType {
    case all
    case hw
    case cw
}

class ScheduleViewModel: NSObject {
    private var networkManager: NetworkManager!
    private var contentType: ContentType = .timeTable {
        didSet {
            updateData()
        }
    }
    public private(set) var schedule = [ScheduleDay]() {
        didSet {
            self.updateDataSource()
            bindScheduleViewModelToController()
        }
    }
    public private(set) var deadlines = [DeadlineDay]() {
        didSet {
            self.updateDataSource()
            bindScheduleViewModelToController()
        }
    }
    
    public lazy var datasource = UITableViewDiffableDataSource<AnyHashable,AnyHashable>(tableView: tableView!) { tableView, indexPath, itemIdentifier in
        switch self.contentType {
        case .timeTable:
            let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.reuseIdentifier , for: indexPath) as! ScheduleTableViewCell
            cell.selectionStyle = .none
            cell.configure(schedule: itemIdentifier as! TimeSlot)
            return cell
        case .assigments:
            let cell = tableView.dequeueReusableCell(withIdentifier: DeadlineTableViewCell.reuseIdentifier , for: indexPath) as! DeadlineTableViewCell
            cell.selectionStyle = .none
            cell.configure(deadline: itemIdentifier as! Deadline)
            return cell
        }
    }
    
    public var bindScheduleViewModelToController: () -> () = {}
    private weak var tableView: UITableView?
    
    // MARK: - Init
    
    init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
        
        
        tableView.dataSource = datasource
        networkManager = NetworkManager()
        updateData()
    }
    
    private func updateDataSource() {
        let sectionIdentifiers: [String]
        var itemBySection = [String: [AnyHashable]]()
        if contentType == .timeTable {
            sectionIdentifiers = self.schedule.map {$0.day}
            self.schedule.forEach( {
                itemBySection[$0.day] = $0.timeSlot
            })
        } else {
            sectionIdentifiers = self.deadlines.map {$0.day}
            self.deadlines.forEach( {
                itemBySection[$0.day] = $0.assignments
            })
        }
        datasource.applySnapshotUsing(sectionIDs: sectionIdentifiers, itemBySection: itemBySection, animatingDifferences: false)
    }
    
    // MARK: - API Calls
    
    private func fetchSchedule() {
        networkManager.getSchedule { schedule, error in
            if let error = error {
                print(error)
            }
            if let schedule = schedule {
                self.schedule = schedule
            }
        }
    }
    
    private func fetchDeadline() {
        networkManager.getDeadline { deadlines, error in
            if let error = error{
                print(error)
            }
            if let deadlines = deadlines {
                self.deadlines = deadlines
            }
        }
    }
    
    private func sortDeadlines() {
        
    }
    
    // MARK: - Internal calls
    
    public func updateData() {
        if contentType == .timeTable {
            fetchSchedule()
            networkManager.cancelDeadline()
        } else {
            fetchDeadline()
            networkManager.cancelSchedule()
        }
    }
    
    public func contentChanged(contentType: ContentType) {
        self.contentType = contentType
    }
    
    public func deadLineContentChanged(_ type: DeadlineContentType) {
    }
}
