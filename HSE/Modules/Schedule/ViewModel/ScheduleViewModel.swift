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

final class ScheduleViewModel {
    typealias TableDataSource = UITableViewDiffableDataSource<AnyHashable,Item>
    
    private var networkManager: NetworkManager?
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
    
   private(set) var schedule = [ScheduleDay]() {
        didSet {
            self.updateDataSource()
            bindScheduleViewModelToController()
        }
    }
    // lazy sort
    // Store fetched deadlines
    private var deadlines = [DeadlineDay]() {
        didSet {
            sortDeadlines()
        }
    }
    // Sorted deadlines ready to be presented
    private(set) var currentdeadlines = [DeadlineDay]() {
        didSet {
            self.updateDataSource()
            bindScheduleViewModelToController()
        }
    }
    
    // MARK: - Data Source
    public lazy var dataSource = TableDataSource (
        tableView: tableView!
    ) { tableView, indexPath, itemIdentifier in
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
            cell.setHeight(to: 80)
            cell.configureShimmer()
            
            return cell
        }
    }
    
    enum Item: Hashable {
        case timeslot(TimeSlot)
        case deadline(Deadline)
        case loading(UUID)
        
        static var loadingItems: [Item] {
            return Array(repeatingExpression: Item.loading(UUID()), count: 8)
        }
    }
    
    public var bindScheduleViewModelToController: () -> () = {}
    private weak var tableView: UITableView?
    
    // MARK: - Init
    // kingFisher
    init(tableView: UITableView) {
        
        self.tableView = tableView
        tableView.dataSource = dataSource
        networkManager = NetworkManager()
        updateData()
    }
    
    // MARK: - Data Source update
    private func updateDataSource() {
        let sectionIdentifiers: [String]
        var itemBySection = [String: [Item]]()
        // transform array into itemBySection form, where Key is a day(Section) values is array of timeslots/deadlines
        if contentType == .timeTable {
            sectionIdentifiers = self.schedule.map { $0.day }
            self.schedule.forEach {
                itemBySection[$0.day] = $0.timeSlot.map { Item.timeslot($0) }
            }
        } else {
            sectionIdentifiers = self.currentdeadlines.map { $0.day }
            self.currentdeadlines.forEach {
                itemBySection[$0.day] = $0.assignments.map { Item.deadline($0) }
            }
        }
        dataSource.applySnapshotUsing(sectionIDs: sectionIdentifiers, itemBySection: itemBySection, animatingDifferences: false)
    }
    
    // вынести в отдельную вьюмодел
    private func sortDeadlines() {
        // depending on user selection, filter deadlines to only homeworks, controlworks or all together
        switch deadlineType {
        case .all:
            currentdeadlines = deadlines
        case .hw:
            var hwDeadlines = [DeadlineDay]()
            deadlines.forEach( {
                let filteredAssinments = $0.assignments.filter {
                    $0.type == .hw
                }
                hwDeadlines.append(DeadlineDay(day: $0.day, assignments: filteredAssinments))
            })
            currentdeadlines = hwDeadlines
        case .cw:
            var cwDeadlines = [DeadlineDay]()
            deadlines.forEach( {
                let filteredAssinments = $0.assignments.filter {
                    $0.type == .cw
                }
                cwDeadlines.append(DeadlineDay(day: $0.day, assignments: filteredAssinments))
            })
            currentdeadlines = cwDeadlines
        }
    }
    
    // MARK: - API Calls
    private func fetchSchedule() {
        networkManager?.getSchedule { schedule, error in
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
        networkManager?.getDeadline { deadlines, error in
            if let error = error{
                print(error)
            }
            if let deadlines = deadlines {
                self.isLoading = false
                self.deadlines = deadlines
            }
        }
    }
    
    // MARK: - Shimmer
    private func setShimmer() {
        dataSource.applySnapshotUsing(sectionIDs: [""], itemBySection: ["":Item.loadingItems], animatingDifferences: false)
    }
    
    // MARK: - Internal calls
    public func updateData() {
        isLoading = true
        if (contentType == .timeTable) {
            fetchSchedule()
            networkManager?.cancelDeadline()
        } else {
            fetchDeadline()
            networkManager?.cancelSchedule()
        }
    }
    
    public func contentChanged(contentType: ContentType) {
        self.contentType = contentType
    }
    
    public func deadLineContentChanged(_ type: DeadlineContentType) {
        deadlineType = type
        sortDeadlines()
    }
}
