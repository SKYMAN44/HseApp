//
//  ScheduleViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.01.2022.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    var navView: ExtendingNavBar?
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .red
        tableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.reuseIdentifier)
        tableView.register(UINib(nibName: "ScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: ScheduleTableViewCell.reuseIdentifier)
        return tableView
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
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
        
        //temp setup
        tableView.frame = CGRect(x: 0, y: 88, width: view.frame.width, height: view.frame.height)
        
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    @objc func calendarButtonTapped() {
        CalendarPopUpView.init().show()
    }
    
    @objc func segmentChanged() {
        switch navView?.choosenSegment {
        case 0:
            print("TimeTable")
        case 1:
            print("Assigment")
        default:
            print("looks like error")
        }
    }
    
}


extension ScheduleViewController: UITableViewDelegate {
    
}

extension ScheduleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Schedule.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.reuseIdentifier , for: indexPath)
        return cell
    }
    
}
