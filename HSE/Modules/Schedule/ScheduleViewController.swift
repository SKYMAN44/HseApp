//
//  ScheduleViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.01.2022.
//

import UIKit

enum ContentType {
    case timeTable
    case assigments
}

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
        
        return tableView
    }()
    
    private var currentContent: ContentType = .timeTable
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = .background.style(.accent)()
        
        // setUp navBar
        setupNavBar()
        
        // tableView setUp
        setupTableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - UI setup
    
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
        
        let segmentViewConstraints = [
            segmentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: navView!.closedHeight!),
            segmentView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            segmentView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            segmentView.heightAnchor.constraint(equalToConstant: 56)
        ]
        
        NSLayoutConstraint.activate(segmentViewConstraints)
    }
    
    
    private func updateView() {
        switch currentContent {
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
            currentContent = .timeTable
        case 1:
            currentContent = .assigments
        default:
            print("looks like error")
        }
        updateView()
        tableView.reloadData()
    }
    
}

 // MARK: - TableView Delegate

// maybe change to diffable datasource

extension ScheduleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard currentContent == .assigments else { return }
        let detailVC = TaskDetailViewController()
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - TableView DataSource

extension ScheduleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch currentContent {
        case .timeTable:
            return ScheduleDay.days.count
        case .assigments:
            return DeadlineDay.days.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentContent {
        case .timeTable:
            return ScheduleDay.days[section].schedule.count
        case .assigments:
            return DeadlineDay.days[section].deadlines.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = .background.style(.firstLevel)()
        
        let label = UILabel()
        label.frame = CGRect.init(x: 16, y: 0, width: headerView.frame.width, height: 15)
        label.font = .customFont.style(.special)()
        label.textColor = .textAndIcons.style(.tretiary)()
        
        switch currentContent {
        case .timeTable:
            label.text = ScheduleDay.days[section].day
        case .assigments:
            label.text = DeadlineDay.days[section].day
        }
        
        headerView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true

        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch currentContent {
        case .timeTable:
            let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.reuseIdentifier , for: indexPath) as! ScheduleTableViewCell
            cell.selectionStyle = .none
            cell.configure(schedule: ScheduleDay.days[indexPath.section].schedule[indexPath.row])
            return cell
        case .assigments:
            let cell = tableView.dequeueReusableCell(withIdentifier: DeadlineTableViewCell.reuseIdentifier , for: indexPath) as! DeadlineTableViewCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
}


// MARK: - Scroll Delegate

extension ScheduleViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        navView?.hide()
    }
}
