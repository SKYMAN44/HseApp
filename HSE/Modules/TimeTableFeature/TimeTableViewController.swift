//
//  TimeTableViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 30.05.2022.
//

import UIKit
import HSESKIT

protocol TimeTableViewControllerScrollDelegate {
    func didScroll(_ scrollView: UIScrollView)
}

final class TimeTableViewController: UIViewController {
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
    private lazy var viewModel = ScheduleViewModel(tableView: tableView, NetworkManager())
    public var delegate: TimeTableViewControllerScrollDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .background.style(.accent)()
        setupTableView()
        tableView.delegate = self
    }
    
    // MARK: - UI setup
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    // можно ли создать свой run loop в swift
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.separatorColor = .clear
        tableView.sectionHeaderHeight = Constants.tableViewHeaderHeight;
        tableView.sectionFooterHeight = Constants.tableViewFooterHeight;
        tableView.backgroundColor = .background.style(.firstLevel)()
        
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        
        tableView.estimatedRowHeight = 82
        tableView.rowHeight = UITableView.automaticDimension

        let constrain = tableView.pinTop(to: view.topAnchor)
        tableView.pin(to: view, [.left, .right, .top, .bottom])
        tableView.pinBottom(to: view.bottomAnchor)
        
        constrain.identifier = "tableHeightConstain"
    }
    
    // MARK: - Interactions
    @objc
    private func refreshData() {
        refreshControl.endRefreshing()
        viewModel.updateData()
    }
    
    public func setupForEmbedingInScrollView() -> UIScrollView {
//        self.tableView.bounces = false
        self.tableView.isScrollEnabled = false
        
        return tableView
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
