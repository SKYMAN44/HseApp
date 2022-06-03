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
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .background.style(.accent)()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "chevronleft"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
        guard let navigationBar = self.navigationController?.navigationBar else { return }
//        navigationBar.addSubview(userImageView)
        chatNameLabel.text = "Professors/Student"
//        navigationBar.addSubview(chatNameLabel)
        
        self.navigationController?.navigationBar.scalesLargeContentImage = true
        self.navigationController?.navigationBar.showsLargeContentViewer = true
        self.navigationController?.navigationBar.largeContentImage = userImageView.image
        self.navigationController?.navigationBar.largeContentTitle = "Professor/Students"
//        userImageView.pin(to: navigationBar, [.top: 0])
//        userImageView.pinCenter(to: navigationBar)
//        userImageView.setHeight(to: Consts.imageSmallSize)
//        chatNameLabel.pinTop(to: userImageView.bottomAnchor, 12)
//        chatNameLabel.pinCenter(to: navigationBar)
//        navigationController?.navigationBar.frame = CGRect(x: navigationBar.frame.minX, y: navigationBar.frame.minY, width: ScreenSize.Width, height: 200)
    }
    
    private func moveAndResize(for height: CGFloat) {
        let coeff: CGFloat = {
            let delta = height - Consts.imageLargeSize
            let heightDifferenceBetweenStates = (Consts.imageLargeSize - Consts.imageSmallSize)
            return delta / heightDifferenceBetweenStates
        }()

        let factor = Consts.imageSmallSize / Consts.imageLargeSize

        let scale: CGFloat = {
            let sizeAddendumFactor = coeff * (1.0 - factor)
            return min(1.0, sizeAddendumFactor + factor)
        }()

        // Value of difference between icons for large and small states
        let sizeDiff = 100 * (1.0 - factor) // 8.0
        let yTranslation: CGFloat = {
            let maxYTranslation = Consts.topInset - Consts.topInset + sizeDiff
            return max(0, min(maxYTranslation, (maxYTranslation - coeff * (Consts.topInset + sizeDiff))))
        }()

        let xTranslation = max(0, sizeDiff - coeff * sizeDiff)

        userImageView.transform = CGAffineTransform.identity
            .scaledBy(x: scale, y: scale)
            .translatedBy(x: xTranslation, y: yTranslation)
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let height = navigationController?.navigationBar.frame.height else { return }
        moveAndResize(for: height)
    }
}
