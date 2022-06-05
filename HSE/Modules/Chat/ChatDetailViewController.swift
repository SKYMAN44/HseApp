//
//  ChatDetailViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 25.05.2022.
//

import UIKit

final class ChatDetailViewController: UIViewController {
    private enum Consts {
        static let imageSmallSize = 10.0
        static let imageLargeSize = 70.0
        static let topInset = 0.0
    }
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.addConstraint(NSLayoutConstraint(item: imageView,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: imageView,
                                                  attribute: .width,
                                                  multiplier: 1,
                                                  constant: 0))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        
        imageView.image = UIImage(named: "testPic.jpg")!.circleMask
        
        return imageView
    }()
    private let chatNameLabel = UILabel()
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        userImageView.removeFromSuperview()
        chatNameLabel.removeFromSuperview()
        navigationController?.navigationBar.prefersLargeTitles = false
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
        let leftBarButton = UIBarButtonItem(
            image: UIImage(named: "chevronleft"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        leftBarButton.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    // MARK: - Navigation
    @objc
    private func goBack() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - GestureDelegate
extension ChatDetailViewController: UIGestureRecognizerDelegate { }


// MARK: - TableViewDelegate
extension ChatDetailViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {}
}
