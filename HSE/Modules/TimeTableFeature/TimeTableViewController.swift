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
    private var viewModel: ScheduleViewModel
    public var delegate: TimeTableViewControllerScrollDelegate?
    
    // MARK: - Init
    init(_ isMyUser: Bool,_ userRefs: UserReference? = nil, networkService: NetworkManager? = nil) {
        // once backend appears configure viewmodel with account to view/ dependency injection of networkService
        self.viewModel = ScheduleViewModel(tableView: tableView, NetworkManager())
        super.init(nibName: nil, bundle: nil)
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
        tableView.delegate = self
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
        viewModel.updateData()
    }
    
    public func setupForEmbedingInScrollView() -> UIScrollView {
        self.tableView.isScrollEnabled = false
        
        return tableView
    }
    
    public func contentChanged(contentType: ContentType) {
        viewModel.contentChanged(contentType: contentType)
    }
    
    public func deadlineContentChanged(_ deadlineType: DeadlineContentType) {
        viewModel.deadLineContentChanged(deadlineType)
    }
}

// MARK: - TableView Delegate
extension TimeTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard viewModel.contentType == .assigments else { return }
        
        let detailVC = TaskDetailViewController(deadline: viewModel.currentdeadlines[indexPath.section].assignments[indexPath.row])
        //        self.hidesBottomBarWhenPushed = true
        //        self.navigationController?.pushViewController(detailVC, animated: true)
        navigationController?.present(detailVC, animated: true)
        //        self.hidesBottomBarWhenPushed = false
    }
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = .background.style(.firstLevel)()
        
        let label = UILabel()
        label.frame = CGRect.init(x: 16, y: 0, width: headerView.frame.width, height: 15)
        label.font = .customFont.style(.special)()
        label.textColor = .textAndIcons.style(.tretiary)()
        if viewModel.isLoading == false {
            switch viewModel.contentType {
            case .timeTable:
                label.text = viewModel.schedule[section].day
            case .assigments:
                label.text = viewModel.currentdeadlines[section].day
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.didScroll(scrollView)
    }
}
