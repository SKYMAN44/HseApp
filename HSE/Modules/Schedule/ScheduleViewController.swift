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

class ScheduleViewController: UIViewController {
    
    var navView: ExtendingNavBar?
    
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
        
        navView?.addTarget(self, action: #selector(calendarButtonTapped) , for: .touchUpInside)
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
        
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true //need to fix
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: tabBarHeight).isActive = true

        tableView.delegate = self
        tableView.dataSource = self
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
        label.font = .systemFont(ofSize: 15, weight: .semibold)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.reuseIdentifier , for: indexPath)
            cell.selectionStyle = .none
            return cell
        case .assigments:
            let cell = tableView.dequeueReusableCell(withIdentifier: DeadlineTableViewCell.reuseIdentifier , for: indexPath)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    
}
