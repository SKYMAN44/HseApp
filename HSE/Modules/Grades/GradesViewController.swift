//
//  GradesViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.01.2022.
//

import UIKit
import HSESKIT

final class GradesViewController: UIViewController {
    typealias DItem = DynamicSegments.Configuration.Item
    typealias DTree = DynamicSegments.Node<DItem>
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(GradeTableViewCell.self, forCellReuseIdentifier: GradeTableViewCell.reuseIdentifier)
        tableView.register(GradeTableViewCell.self, forCellReuseIdentifier: GradeTableViewCell.shimmerReuseIdentifier)
        
        return tableView
    }()
    
    private var refreshControl: UIRefreshControl!
    private lazy var viewModel = GradeViewModel(tableView: tableView)
    private var filterView = DynamicSegments(options: getConfiguration())
    
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
    
    private static func getConfiguration() -> DTree {
        var node = DTree(DItem(presentingName: "__"), childrenCategory: DItem(presentingName: "Semester"))
        var node1 = DTree(DItem(presentingName: "Semester 1"), childrenCategory: DItem(presentingName: "Module"))
        var node2 = DTree(DItem(presentingName: "Semester 2"), childrenCategory: DItem(presentingName: "Module"))
        var node3 = DTree(DItem(presentingName: "Semester 1&2"), childrenCategory: DItem(presentingName: "Module"))
        
        var node4 = DTree(DItem(presentingName: "Module 1"), childrenCategory: DItem(presentingName: "Type"))
        var node5 = DTree(DItem(presentingName: "Module 2"), childrenCategory: DItem(presentingName: "Type"))
        var node8 = DTree(DItem(presentingName: "Module 3"), childrenCategory: DItem(presentingName: "Type"))
        var node9 = DTree(DItem(presentingName: "Module 4"), childrenCategory: DItem(presentingName: "Type"))
        
        let node6 = DTree(DItem(presentingName: "HomeWork"), childrenCategory: DItem(presentingName: "Subject"))
        let node7 = DTree(DItem(presentingName: "CW"), childrenCategory: DItem(presentingName: "Subject"))
        
        node5.add(child: [node6])
        node4.add(child: [node6, node7])
        node8.add(child: [node6, node7])
        node9.add(child: [node6, node7])
        node1.add(child: [node4, node5])
        node2.add(child: [node8, node9])
        node.add(child: [node1, node2, node3])
        
        return node
        
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
        
        view.addSubview(filterView)
        
        filterView.backgroundColor = .background.style(.accent)()
        filterView.pin(to: view, [.left, .right])
        filterView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        filterView.closedHeight = 60
        filterView.heightConstraintReference = filterView.setHeight(to: 60)
        
        setupTableView()
    }
    
    private func setupTableView() {
        view.insertSubview(tableView, belowSubview: filterView)
        
        tableView.separatorColor = .clear
        tableView.backgroundColor = .background.style(.firstLevel)()
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        tableView.rowHeight = 48.0
        
        tableView.pin(to: view, [.left, .right])
        tableView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor, 0)
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor, filterView.closedHeight)
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
