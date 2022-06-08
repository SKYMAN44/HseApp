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
    public private(set) var deadlineType: DeadlineContentType = .all
    public private(set) var contentType: ContentType = .timeTable {
        didSet {
            deadlineType = .all
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
    
    private var currentPage: Int = 1
    private var scheduleSectionsIdentifiers = [String]()
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
    init(_ viewController: TimeTableScreen, tableView: UITableView, _ deadlineNetworkManager: DeadlineNetworkManager, _ scheduleNetworkManager: ScheduleNetworkManager) {
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
        let sectionIdentifiers: [String]
        var itemBySection = [String: [Item]]()
        // transform array into itemBySection form, where Key is a day(Section) values is array of timeslots/deadlines
        if contentType == .timeTable {
            guard let scheduleResponse = scheduleResponse else { return }
            
            itemBySection = scheduleResponse.timeTable.mapValues { $0.map {
                Item.timeslot(TimeSlot(from: $0, convertDates: true))
            }}
            
            let temp: [Date] = scheduleResponse.timeTable.keys.lazy.compactMap { (strDate) in
                if let date = strDate.description.convertStringToDate() {
                    return date
                }
                else {
                    return nil
                }
            }.sorted(by: { $0.compare($1) == .orderedAscending })
            
            sectionIdentifiers = temp.map( { $0.convertFullDateToString() })
            self.scheduleSectionsIdentifiers = sectionIdentifiers
        } else {
            sectionIdentifiers = self.currentdeadlines.map { $0.day }
            self.currentdeadlines.forEach {
                itemBySection[$0.day] = $0.assignments.map { Item.deadline($0) }
            }
        }
        DispatchQueue.main.async {
            self.dataSource.applySnapshotUsing(
                sectionIDs: sectionIdentifiers,
                itemBySection: itemBySection,
                animatingDifferences: false
            )
        }
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
                    $0.deadlineType == .hw
                }
                hwDeadlines.append(DeadlineDay(day: $0.day, assignments: filteredAssinments))
            })
            currentdeadlines = hwDeadlines
        case .cw:
            var cwDeadlines = [DeadlineDay]()
            deadlines.forEach( {
                let filteredAssinments = $0.assignments.filter {
                    $0.deadlineType == .cw
                }
                cwDeadlines.append(DeadlineDay(day: $0.day, assignments: filteredAssinments))
            })
            currentdeadlines = cwDeadlines
        }
    }
    
    // MARK: - Fetching Data
    private func fetchOriginalSchedule() {
        timeTableNetworkManager?.getSchedule(1) { schedule, error in
            if let error = error {
                print(error)
            }
            if let schedule = schedule {
                self.isLoading = false
                self.currentPage = 1
                self.scheduleResponse = schedule
            }
        }
    }
    
    private func fetchMoreSchedule() {
        guard !isLoading else { return }
        guard scheduleResponse?.pageNum != currentPage
        else {
            return
        }
        isLoading = true
        timeTableNetworkManager?.getSchedule(currentPage + 1) { schedule, error in
            if let error = error {
                print(error)
            }
            if let schedule = schedule {
                self.currentPage += 1
                self.isLoading = false
                self.scheduleResponse?.timeTable.merge(schedule.timeTable) { (current, _) in current }
            }
        }
    }
    
    private func fetchDeadline() {
        deadlineNetworkManager?.getDeadline(1) { deadlines, error in
            if let error = error{
                print(error)
            }
            if let deadlines = deadlines {
                self.assignmentsResponse = deadlines
                self.isLoading = false
            }
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
                    self.fetchOriginalSchedule()
                    self.deadlineNetworkManager?.cancelRequest()
                } else {
                    self.fetchDeadline()
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
        sortDeadlines()
    }
}

// MARK: - TableView Delegate
extension ScheduleViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard contentType == .assigments, !isLoading
        else { return }
        
        let detailVC = TaskDetailViewController(deadline: currentdeadlines[indexPath.section].assignments[indexPath.row])
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
                label.text = currentdeadlines[section].day
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
        let position = scrollView.contentOffset.y
        if position > ScreenSize.Height {
            guard !isLoading  else { return }
            fetchMoreSchedule()
        }
        viewController?.delegate?.didScroll(scrollView)
    }
}
