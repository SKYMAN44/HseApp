//
//  ScheduleViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.01.2022.
//

import UIKit

let tempArray: [String: Int?] = ["All": 123,"Homework": nil,"Midterm": 20]

final class ScheduleViewController: UIViewController {
    private var navView: ExtendingNavBar?
    private var segmentView: SegmentView = {
        let segmentView = SegmentView(frame: .zero)
        segmentView.backgroundColor = .background.style(.accent)()
        
        return segmentView
    }()
    
    private var tableView: UITableView = {
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
//                if let refreshC = self.refreshControl {
//                    refreshC.perform(#selector(UIRefreshControl.endRefreshing), with: nil, afterDelay: 0)
//                }
            }
        }
        viewModel.updateData()
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
    
    @objc
    private func refreshData() {
        refreshControl.endRefreshing()
        viewModel.updateData()
    }
    
    private func setupNavBar() {
        navView = ExtendingNavBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        navView?.color = .background.style(.accent)()
        
        navView?.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
        navView?.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        view.addSubview(navView!)
        
        navView?.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            navView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navView!.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            navView!.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            navView!.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        navView?.addSubviews()
        
        constraints[3].identifier = "heightConstrain"
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupTableView() {
        view.insertSubview(tableView, belowSubview: navView!)
        
        tableView.separatorColor = .clear
        tableView.sectionHeaderHeight = 30;
        tableView.sectionFooterHeight = 0.0;
        tableView.backgroundColor = .background.style(.firstLevel)()
        
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        
        tableView.estimatedRowHeight = 82
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.translatesAutoresizingMaskIntoConstraints = false

        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: navView!.closedHeight!),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        tableViewConstraints[0].identifier = "tableHeightConstain"
        
        NSLayoutConstraint.activate(tableViewConstraints)
    }
    
    private func addSegmentView() {
        segmentView.setTitles(titles: tempArray)
        view.addSubview(segmentView)
        
        segmentView.translatesAutoresizingMaskIntoConstraints = false
        segmentView.delegate = self
        
        let segmentViewConstraints = [
            segmentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: navView!.closedHeight!),
            segmentView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            segmentView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            segmentView.heightAnchor.constraint(equalToConstant: 56)
        ]
        
        NSLayoutConstraint.activate(segmentViewConstraints)
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
    
}

 // MARK: - TableView Delegate

extension ScheduleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard viewModel.contentType == .assigments else { return }
        
        let detailVC = TaskDetailViewController(deadline: viewModel.currentdeadlines[indexPath.section].assignments[indexPath.row])
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailVC, animated: true)
        self.hidesBottomBarWhenPushed = false
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

extension ScheduleViewController: SegmentViewDelegate {
    func segmentChosen(index: Int) {
        switch index {
        case 1:
            viewModel.deadLineContentChanged(.hw)
        case 2:
            viewModel.deadLineContentChanged(.cw)
        default:
            viewModel.deadLineContentChanged(.all)
        }
    }
    
}
