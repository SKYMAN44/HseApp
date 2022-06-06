//
//  TimeTableViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 30.05.2022.
//

import UIKit
import HSESKIT

final class TimeTableViewController: UIViewController, TimeTableModule {
    private enum Constants {
        static let tableViewHeaderHeight = 30.0
        static let tableViewFooterHeight = 0.0
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.reuseIdentifier)
        tableView.register(DeadlineTableViewCell.self, forCellReuseIdentifier: DeadlineTableViewCell.reuseIdentifier)
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.shimmerReuseIdentifier)
        tableView.register(DeadlineTableViewCell.self, forCellReuseIdentifier: DeadlineTableViewCell.shimmerReuseIdentifier)
        
        return tableView
    }()
    
    private var refreshControl: UIRefreshControl!
    private var viewModel: ScheduleViewModel?
    public var delegate: TimeTableViewControllerScrollDelegate?
    
    // MARK: - Init
    init(_ isMyUser: Bool,_ userRefs: UserReference? = nil, networkService: NetworkManager? = nil) {
        // once backend appears configure viewmodel with account to view/ dependency injection of networkService
        super.init(nibName: nil, bundle: nil)
        self.viewModel = ScheduleViewModel(self, tableView: tableView, NetworkManager())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .background.style(.accent)()
        setupTableView()
        setupRefreshControl()
    }
    
    // MARK: - UI setup
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.separatorColor = .clear
        tableView.sectionHeaderHeight = Constants.tableViewHeaderHeight;
        tableView.sectionFooterHeight = Constants.tableViewFooterHeight;
        tableView.backgroundColor = .background.style(.firstLevel)()
        
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        
        tableView.estimatedRowHeight = 82
        tableView.rowHeight = UITableView.automaticDimension
        tableView.pin(to: view, [.left, .right, .top, .bottom])
    }
    
    // MARK: - Interactions
    @objc
    private func refreshData() {
        refreshControl.endRefreshing()
        viewModel?.updateData()
    }
    
    public func setupForEmbedingInScrollView() -> UIScrollView {
        self.tableView.isScrollEnabled = false
        
        return tableView
    }
    
    public func contentChanged(contentType: ContentType) {
        viewModel?.contentChanged(contentType: contentType)
    }
    
    public func deadlineContentChanged(_ deadlineType: DeadlineContentType) {
        viewModel?.deadLineContentChanged(deadlineType)
    }
}
