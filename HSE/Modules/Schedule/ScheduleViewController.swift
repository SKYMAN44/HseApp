//
//  ScheduleViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.01.2022.
//

import UIKit
import HSESKIT

final class ScheduleViewController: UIViewController {
    
    let tempArray: [PageItem] = [
        PageItem(title: "All", notifications: 132),
        PageItem(title: "HomeWork", notifications: 0),
        PageItem(title: "Midterm", notifications: 13)]
    
    private enum Constants {
        static let tableViewHeaderHeight = 30.0
        static let tableViewFooterHeight = 0.0
    }
    
    private var navView: ExtendingNavBar?
    private let segmentView: PaginationView = {
        let segmentView = PaginationView(frame: .zero)
        segmentView.backgroundColor = .background.style(.accent)()
        
        return segmentView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.reuseIdentifier)
        tableView.register(DeadlineTableViewCell.self, forCellReuseIdentifier: DeadlineTableViewCell.reuseIdentifier)
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.shimmerReuseIdentifier)
        tableView.register(DeadlineTableViewCell.self, forCellReuseIdentifier: DeadlineTableViewCell.shimmerReuseIdentifier)
        
        return tableView
    }()
    
    private var refreshControl: UIRefreshControl!
    private var currentContent: ContentType = .timeTable
    private lazy var viewModel = ScheduleViewModel(tableView: tableView)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .background.style(.accent)()
        // setUp navBar
        setupNavBar()
        // tableView setUp
        setupTableView()
        setupRefreshControl()
        
        tableView.delegate = self
        viewModel.bindScheduleViewModelToController = {
            DispatchQueue.main.async {
            }
        }
//        let displayLink = CADisplayLink(target: self, selector: #selector(updateLoop(_:)))
//        displayLink.add(to: .current, forMode: .common)
    }
    
    // fps performance
    private var lastTimeStep = CACurrentMediaTime()
    
    @objc
    private func updateLoop(_ displayLink: CADisplayLink) {
        defer { lastTimeStep = displayLink.timestamp }
        let fps = 1 / (displayLink.timestamp - lastTimeStep)
        print("FPS: \(fps)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - UI setup
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupNavBar() {
        navView = ExtendingNavBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        navView?.color = .background.style(.accent)()
        // переделать
        
        navView?.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
        navView?.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        view.addSubview(navView!)
        
        navView?.pin(to: view, [.left, .right])
        navView?.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        let constrain = navView?.setHeight(to: 60)
        navView?.addSubviews()
        
        constrain?.identifier = "heightConstrain"
    }
    
    private func setupTableView() {
        view.insertSubview(tableView, belowSubview: navView!)
        
        tableView.separatorColor = .clear
        tableView.sectionHeaderHeight = Constants.tableViewHeaderHeight;
        tableView.sectionFooterHeight = Constants.tableViewFooterHeight;
        tableView.backgroundColor = .background.style(.firstLevel)()
        
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        
        tableView.estimatedRowHeight = 82
        tableView.rowHeight = UITableView.automaticDimension

        let constrain = tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, navView!.closedHeight!)
        tableView.pin(to: view, [.left, .right])
        tableView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        
        constrain.identifier = "tableHeightConstain"
    }
    
    private func addSegmentView() {
        segmentView.setTitles(titles: tempArray)
        view.addSubview(segmentView)
        
        segmentView.delegate = self
        
        segmentView.pin(to: view, [.left, .right])
        segmentView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, navView!.closedHeight!)
        segmentView.setHeight(to: 56)
    }
    
    // MARK: - Interactions
    @objc
    private func calendarButtonTapped() {
        CalendarPopUpView.init().show()
    }
    
    @objc
    private func segmentChanged() {
        switch navView?.choosenSegment {
        case 0:
            updateView(content: .timeTable)
            viewModel.contentChanged(contentType: .timeTable)
        case 1:
            updateView(content: .assigments)
            viewModel.contentChanged(contentType: .assigments)
        default:
            print("looks like error")
        }
    }
    
    @objc
    private func refreshData() {
        refreshControl.endRefreshing()
        viewModel.updateData()
    }
    
    private func updateView(content: ContentType) {
        switch content {
        case .timeTable:
            //remove segmented view
            segmentView.removeFromSuperview()
            
            for constraint in self.view.constraints {
                if constraint.identifier == "tableHeightConstain" {
                    constraint.constant = navView!.closedHeight!
                }
            }
        case .assigments:
            addSegmentView()
            //place navView on top of segmentView
            view.bringSubviewToFront(navView!)
            // change top constraint of tableview so segmentView not covers it
            for constraint in self.view.constraints {
                if constraint.identifier == "tableHeightConstain" {
                    constraint.constant = 56 + navView!.closedHeight!
                }
            }
            view.layoutIfNeeded()
        }
    }
}

 // MARK: - TableView Delegate
extension ScheduleViewController: UITableViewDelegate {
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
}

// MARK: - Scroll Delegate
extension ScheduleViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navView?.hide()
    }
}


// MARK: - SegmentView Delegate
extension ScheduleViewController: PaginationViewDelegate {
    func segmentChosen(index: Int) {
        var vm: DeadlineContentType = .all
        switch index {
        case 1:
            vm = .hw
        case 2:
            vm = .cw
        default:
            vm = .all
        }
        viewModel.deadLineContentChanged(vm)
    }
}
