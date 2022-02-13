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
    private var deadlineType: DeadlineContentType = .all
    public private(set) var contentType: ContentType = .timeTable {
        didSet {
            updateData()
        }
    }
    public var isLoading: Bool = false {
        didSet {
            if(isLoading) {
                setShimmer()
            }
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
            sortDeadlines()
        }
    }
    
    public private(set) var currentdeadlines = [DeadlineDay]() {
        didSet {
            self.updateDataSource()
            bindScheduleViewModelToController()
        }
    }
    
    enum Item: Hashable {
        case timeslot(TimeSlot)
        case deadline(Deadline)
        case loading(UUID)
        
        var isLoading: Bool {
            switch self {
            case .loading(_):
                return true
            default:
                return false
            }
        }
        
        static var loadingItems: [Item] {
            return Array(repeatingExpression: Item.loading(UUID()), count: 8)
        }
    }
    
    public lazy var datasource = UITableViewDiffableDataSource<AnyHashable,Item>(tableView: tableView!) { tableView, indexPath, itemIdentifier in
        switch (itemIdentifier, self.contentType) {
        case (.timeslot(let timeslot), _ ):
            let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.reuseIdentifier , for: indexPath) as! ScheduleTableViewCell
            cell.selectionStyle = .none
            cell.configure(schedule: timeslot)
            
            return cell
        case (.deadline(let deadline), _):
            let cell = tableView.dequeueReusableCell(withIdentifier: DeadlineTableViewCell.reuseIdentifier , for: indexPath) as! DeadlineTableViewCell
            cell.selectionStyle = .none
            cell.configure(deadline: deadline)
            
            return cell
        case (.loading(_), .timeTable):
            let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.shimmerReuseIdentifier , for: indexPath) as! ScheduleTableViewCell
            cell.selectionStyle = .none
            cell.setHeight(to: 100)
            cell.configureShimmer()
            
            return cell
        case (.loading(_), .assigments):
            let cell = tableView.dequeueReusableCell(withIdentifier: DeadlineTableViewCell.shimmerReuseIdentifier , for: indexPath) as! DeadlineTableViewCell
            cell.selectionStyle = .none
            cell.configureShimmer()
            
            return cell
        }
    }
    
    public var bindScheduleViewModelToController: () -> () = {}
    private weak var tableView: UITableView?
    
    // MARK: - Init
    
    init(tableView: UITableView) {
        super.init()
        
        self.tableView = tableView
        tableView.dataSource = datasource
        networkManager = NetworkManager()
    }
    
    private func updateDataSource() {
        let sectionIdentifiers: [String]
        var itemBySection = [String: [Item]]()
        if contentType == .timeTable {
            sectionIdentifiers = self.schedule.map {$0.day}
            self.schedule.forEach( {
                itemBySection[$0.day] = $0.timeSlot.map({ Item.timeslot($0)})
            })
        } else {
            sectionIdentifiers = self.currentdeadlines.map {$0.day}
            self.currentdeadlines.forEach( {
                itemBySection[$0.day] = $0.assignments.map({ Item.deadline($0)})
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
                self.isLoading = false
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
                self.isLoading = false
                self.deadlines = deadlines
            }
        }
    }
    
    // MARK: - shimmer
    
    private func setShimmer() {
        datasource.applySnapshotUsing(sectionIDs: [""], itemBySection: ["":Item.loadingItems], animatingDifferences: false)
    }
    
    private func sortDeadlines() {
        switch deadlineType {
        case .all:
            currentdeadlines = deadlines
        case .hw:
            currentdeadlines = deadlines
        case .cw:
            currentdeadlines = deadlines
        }
    }
    
    // MARK: - Internal calls
    
    public func updateData() {
        isLoading = true
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
