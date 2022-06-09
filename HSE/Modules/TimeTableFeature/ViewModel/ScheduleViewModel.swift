//
//  ScheduleDayViewModel.swift
//  HSE
//
//  Created by Дмитрий Соколов on 15.01.2022.
//

import Foundation
import UIKit

final class ScheduleViewModel: NSObject, TimeTableFeatureLogic {
    private typealias TableDataSource = UITableViewDiffableDataSource<AnyHashable,Item>
    
    private var deadlineNetworkManager: DeadlineNetworkManager?
    private var timeTableNetworkManager: ScheduleNetworkManager?
    public private(set) var deadlineType: DeadlineContentType = .all {
        didSet {
            sortDeadlines()
        }
    }
    public private(set) var contentType: ContentType = .timeTable {
        didSet {
            deadlineType = .all
            changeContent()
        }
    }
    public var isLoading: Bool = false {
        didSet {
            if(isLoading) {
                setShimmer()
            }
        }
    }
    
    private var currentSchedulePage: Int = 1
    private var currentAssignmentPage: Int = 1
    private var scheduleSectionsIdentifiers = [String]()
    private var assignmentsSectionIdentifier = [String]()
    private(set) var scheduleResponse: ScheduleApiResponse? {
        didSet {
            updateDataSource()
        }
    }
    private(set) var assignmentsResponse: DeadlineApiResponse? {
        didSet {
            sortDeadlines()
        }
    }
    private(set) var currentAssignments = DeadlineDictionary() {
        didSet {
            self.updateDataSource()
        }
    }
    
    // MARK: - Data Source
    private lazy var dataSource = TableDataSource (
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
    
    private enum Item: Hashable {
        case timeslot(TimeSlot)
        case deadline(Deadline)
        case loading(UUID)
        
        static let shimmerSectionIdentifier = "Shimmer"
        static var loadingItems: [Item] {
            return Array(repeatingExpression: Item.loading(UUID()), count: 8)
        }
    }
    private weak var viewController: TimeTableScreen?
    private weak var tableView: UITableView?
    
    // MARK: - Init
    // kingFisher?
    init(
        _ viewController: TimeTableScreen,
        tableView: UITableView,
        _ deadlineNetworkManager: DeadlineNetworkManager,
        _ scheduleNetworkManager: ScheduleNetworkManager
    ) {
        self.viewController = viewController
        self.tableView = tableView
        self.deadlineNetworkManager = deadlineNetworkManager
        self.timeTableNetworkManager = scheduleNetworkManager
        
        super.init()
        
        tableView.dataSource = dataSource
        self.tableView?.delegate = self
        
        updateData()
    }
    
    // MARK: - Data Source update
    private func updateDataSource() {
        var sectionIdentifiers = [String]()
        var itemBySection = [String: [Item]]()
        // transform array into itemBySection form, where Key is a day(Section) values is array of timeslots/deadlines
        if contentType == .timeTable {
            guard let scheduleResponse = scheduleResponse else { return }
            
            itemBySection = scheduleResponse.timeTable.mapValues { $0.map {
                Item.timeslot(TimeSlot(from: $0, convertDates: true))
            }}
            
            setSectionIdentifiers(&sectionIdentifiers, scheduleResponse.timeTable.keys)
            self.scheduleSectionsIdentifiers = sectionIdentifiers
        } else {
            itemBySection = currentAssignments.mapValues { $0.map {
                Item.deadline(Deadline(from: $0, convertDates: true))
            }}
            
            setSectionIdentifiers(&sectionIdentifiers, currentAssignments.keys)
            self.assignmentsSectionIdentifier = sectionIdentifiers
        }
        DispatchQueue.main.async {
            self.dataSource.applySnapshotUsing(
                sectionIDs: sectionIdentifiers,
                itemBySection: itemBySection,
                animatingDifferences: false
            )
            // check if needed to fetchMore
            self.checkToFetchMoreData()
        }
    }
    
    private func changeContent() {
        guard !isLoading else { return }
        clearDataSource {
            self.isLoading = true
            DispatchQueue.main.async {
                if(self.contentType == .timeTable) {
                    if self.scheduleResponse == nil {
                        self.fetchSchedule(1)
                    } else {
                        self.updateDataSource()
                        self.isLoading = false
                    }
                    self.deadlineNetworkManager?.cancelRequest()
                } else {
                    if self.assignmentsResponse == nil {
                        self.fetchDeadline(1)
                    } else {
                        self.sortDeadlines()
                        self.isLoading = false
                    }
                    self.timeTableNetworkManager?.cancelRequest()
                }
            }
        }
    }
    
    private func setSectionIdentifiers<T>(_ identifiers: inout [String], _ keys: Dictionary<String,[T]>.Keys) {
        let temp: [Date] = keys.lazy.compactMap { (strDate) in
            if let date = strDate.convertStringToDate() {
                return date
            } else {
                return nil
            }
        }.sorted(by: { $0.compare($1) == .orderedAscending })
        identifiers = temp.map { $0.convertFullDateToString() }
    }
    
    // вынести в отдельную вьюмодел
    // MARK: - Assignments Sort
    private func sortDeadlines() {
        guard let assignments = assignmentsResponse?.assignments else { return }
        // depending on user selection, filter deadlines to only homeworks, controlworks or all together
        switch deadlineType {
        case .all:
            currentAssignments = assignments
        case .hw:
            currentAssignments = assignments.mapValues {
                $0.filter { $0.deadlineType == .hw }
            }
        case .cw:
            currentAssignments = assignments.mapValues {
                $0.filter { $0.deadlineType == .cw}
            }
        }
    }
    
    // MARK: - Fetching Data
    private func fetchSchedule(_ page: Int) {
        timeTableNetworkManager?.getSchedule(page) { schedule, error in
            if let error = error {
                print(error)
            }
            if let schedule = schedule {
                self.isLoading = false
                self.currentSchedulePage = page
                if(page > 1) {
                    self.scheduleResponse?.timeTable.merge(schedule.timeTable) { (current, _) in current }
                } else {
                    self.scheduleResponse = schedule
                }
            }
        }
    }
    
    private func fetchDeadline(_ page: Int) {
        deadlineNetworkManager?.getDeadline(page) { deadlines, error in
            if let error = error{
                print(error)
            }
            if let deadlines = deadlines {
                self.isLoading = false
                self.currentAssignmentPage = page
                if(page > 1) {
                    self.assignmentsResponse?.assignments.merge(deadlines.assignments) { (current, _) in current }
                } else {
                    self.assignmentsResponse = deadlines
                }
            }
        }
    }
    
    private func fetchMore() {
        if contentType == .timeTable {
            guard scheduleResponse?.pageNum != currentSchedulePage else { return }
            isLoading = true
            fetchSchedule(currentSchedulePage + 1)
        } else {
            guard assignmentsResponse?.pageNum != currentAssignmentPage else { return }
            isLoading = true
            fetchDeadline(currentAssignmentPage + 1)
        }
    }
    
    // MARK: - Shimmer
    private func setShimmer() {
        var snapshot = dataSource.snapshot()
        if snapshot.sectionIdentifiers.contains(Item.shimmerSectionIdentifier) {
            snapshot.deleteSections([Item.shimmerSectionIdentifier])
        }
        snapshot.appendSections([Item.shimmerSectionIdentifier])
        snapshot.appendItems(Item.loadingItems, toSection: Item.shimmerSectionIdentifier)
        
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: false, completion: nil)
        }
    }
    
    private func clearDataSource(completion: @escaping () -> ()) {
        DispatchQueue.main.async {
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteAllItems()
            self.dataSource.apply(snapshot, animatingDifferences: false) {
                completion()
            }
        }
    }
    
    // MARK: - External calls
    public func updateData() {
        /* function is called in case of firstLoad, content switch or reload triggered by user
            hence dataSource needed to be cleread to put shimmer on whole collection view
         */
        guard !isLoading else { return }
        clearDataSource {
            self.isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                if(self.contentType == .timeTable) {
                    self.fetchSchedule(1)
                    self.deadlineNetworkManager?.cancelRequest()
                } else {
                    self.fetchDeadline(1)
                    self.timeTableNetworkManager?.cancelRequest()
                }
            }
        }
    }
    
    public func contentChanged(contentType: ContentType) {
        self.contentType = contentType
    }
    
    public func deadLineContentChanged(_ type: DeadlineContentType) {
        deadlineType = type
    }
    
    private func checkToFetchMoreData() {
        guard let table = self.tableView else { return }
        if let sections = table.dataSource?.numberOfSections?(in: table),
            sections > 0 {
            // find indexPath for last element
            let sectionIdentifier = dataSource.snapshot().sectionIdentifiers[sections - 1]
            let items = dataSource.snapshot().numberOfItems(inSection: sectionIdentifier)
            // convert Row frame to common coordinates
            let rowFrame = table.rectForRow(at: IndexPath(row: items-1, section: sections-1))
            let newRect = table.convert(rowFrame, to: table.superview)
            // if last cell is visible on screen start fetcheing more data
            if(table.frame.contains(newRect)) {
                guard !isLoading  else { return }
                fetchMore()
            }
        }
    }
}

// MARK: - TableView Delegate
extension ScheduleViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard contentType == .assigments, !isLoading
        else { return }
        
        let detailVC = TaskDetailViewController(deadline: Deadline(id: 1, deadlineType: .cw, courseName: "", assignmentName: "", deadlineTime: "", submissionTime: "0"))
        viewController?.navigationController?.present(detailVC, animated: true)
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = .background.style(.firstLevel)()
        
        let label = UILabel()
        label.frame = CGRect.init(x: 16, y: 0, width: headerView.frame.width, height: 15)
        label.font = .customFont.style(.special)()
        label.textColor = .textAndIcons.style(.tretiary)()
        if isLoading == false {
            switch contentType {
            case .timeTable:
                label.text = scheduleSectionsIdentifiers[section].getTodayWeekDay()
            case .assigments:
                label.text = assignmentsSectionIdentifier[section].getTodayWeekDay()
            }
        } else {
            label.text = ""
        }
        
        headerView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        
        return headerView
    }
    
    // MARK: - Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewController?.delegate?.didScroll(scrollView)
        
        self.checkToFetchMoreData()
    }
}
