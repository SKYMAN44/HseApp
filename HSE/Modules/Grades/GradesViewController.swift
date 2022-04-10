//
//  GradesViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.01.2022.
//

import UIKit

final class GradesViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(GradeTableViewCell.self, forCellReuseIdentifier: GradeTableViewCell.reuseIdentifier)
        tableView.register(GradeTableViewCell.self, forCellReuseIdentifier: GradeTableViewCell.shimmerReuseIdentifier)
        
        return tableView
    }()
    
    private var refreshControl: UIRefreshControl!
    private lazy var viewModel = GradeViewModel(tableView: tableView)
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupView()
        setupRefreshControl()
        
        tableView.delegate = self
        
        viewModel.bindGradeViewModelToController = {
            // do nothing
        }
    }
    
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
    
    // MARK: - UI setup
    private func setupView() {
        self.view.backgroundColor = .background.style(.accent)()
        self.navigationController?.navigationBar.backgroundColor = .background.style(.accent)()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.navigationItem.title = "Grades"
        
        setupTableView()
    }
    
    private func setupTableView() {
        self.view.addSubview(tableView)
        
        tableView.separatorColor = .clear
        tableView.backgroundColor = .background.style(.firstLevel)()
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        tableView.rowHeight = 48.0
        
        tableView.pin(to: view, [.left, .right])
        tableView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 0)
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, 0)
    }

}

// MARK: - Table Delegate
extension GradesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = TaskDetailViewController(deadline: Deadline(id: 1, type: .cw, subjectName: "", assigmentName: "", deadlineTime: "", sumbisionTIme: ""))
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}
