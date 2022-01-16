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

let tempArray: [String] = ["all","Homework","Midterm"]

class ScheduleViewController: UIViewController {
    
    var navView: ExtendingNavBar?
    
    var segmentView: SegmentView?
    
    var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "ScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: ScheduleTableViewCell.reuseIdentifier)
        
        tableView.register(DeadlineTableViewCell.self, forCellReuseIdentifier: DeadlineTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "DeadlineTableViewCell", bundle: nil), forCellReuseIdentifier: DeadlineTableViewCell.reuseIdentifier)
        
        return tableView
    } ()
    
    private let refreshControl = UIRefreshControl()
    
    private var currentContent: ContentType = .timeTable
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        // setUp navBar
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = UIColor(named: "BackgroundAccent")!
        
        navView = ExtendingNavBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 60))
        navView?.color = UIColor(named: "BackgroundAccent")!
        
        navView?.addSubviews()
        
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
        
        constraints[3].identifier = "heightConstrain"
        
        NSLayoutConstraint.activate(constraints)
        
        let tabBarHeight = self.tabBarController!.tabBar.frame.size.height
        
        // tableView setUp
        
        tableView.separatorColor = .clear
        tableView.sectionHeaderHeight = 30;
        tableView.sectionFooterHeight = 0.0;
        tableView.backgroundColor = .white
        
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        
        tableView.estimatedRowHeight = 82
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.translatesAutoresizingMaskIntoConstraints = false

        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ]
        
        tableViewConstraints[0].identifier = "tableHeightConstain"
        
        NSLayoutConstraint.activate(tableViewConstraints)
        

        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    private func updateView() {
        
        switch currentContent {
        case .timeTable:
            //remove segmented view
            guard let view = segmentView else {return}
            view.removeFromSuperview()
            
            for constraint in self.view.constraints {
                if constraint.identifier == "tableHeightConstain" {
                    constraint.constant = 60
                }
            }
            
        case .assigments:
            
            // add segmented view
            segmentView = SegmentView(frame: CGRect(x: 0, y: 108, width: view.frame.width, height: 56))
            segmentView?.setTitles(titles: tempArray)
            segmentView?.backgroundColor = UIColor(named: "BackgroundAccent")!
            
            view.addSubview(segmentView!)
            
            let segmentViewConstraints = [
                segmentView!.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
                segmentView!.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
                segmentView!.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
                segmentView!.heightAnchor.constraint(equalToConstant: 56)
            ]
            
            NSLayoutConstraint.activate(segmentViewConstraints)
            
            //place navView on top of segmentView
            view.bringSubviewToFront(navView!)
            
            // change top constraint of tableview so segmentView not covers it
            for constraint in self.view.constraints {
                if constraint.identifier == "tableHeightConstain" {
                    constraint.constant = 116
                }
            }
            view.layoutIfNeeded()
            
        }
    }
    
    @objc func calendarButtonTapped() {
        CalendarPopUpView.init().show()
    }
    
    @objc func segmentChanged() {
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

 // MARK: - TableView

// maybe change to diffable datasource

extension ScheduleViewController: UITableViewDelegate {
    
}

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
        headerView.backgroundColor = .white
        
        let label = UILabel()
        label.frame = CGRect.init(x: 16, y: 0, width: headerView.frame.width, height: 15)
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemGray3
        
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
