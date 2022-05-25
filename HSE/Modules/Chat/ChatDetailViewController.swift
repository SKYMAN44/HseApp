//
//  ChatDetailViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 25.05.2022.
//

import UIKit

final class ChatDetailViewController: UIViewController {
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            ChatDetailTableViewCell.self,
            forCellReuseIdentifier: ChatDetailTableViewCell.reuseIdentifier
        )
        tableView.register(
            ChatDetailHeaderTableViewCell.self,
            forCellReuseIdentifier: ChatDetailHeaderTableViewCell.reuseIdentifier
        )
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = .clear
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        
        return tableView
    }()
    private var viewModel: ChatDetailViewModel
    
    // MARK: - Init
    init() {
        self.viewModel = ChatDetailViewModel(tableView)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupView()
    }

    // MARK: - setup UI
    private func setupView() {
        view.backgroundColor = .background.style(.accent)()
        tableView.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.pin(to: view, [.left, .right, .bottom])
        tableView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.backgroundColor = .background.style(.accent)()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "chevronleft"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
    }
    
    // MARK: - Navigation
    @objc
    private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - GestureDelegate
extension ChatDetailViewController: UIGestureRecognizerDelegate { }
