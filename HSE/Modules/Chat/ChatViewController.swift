//
//  ChatViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 28.01.2022.
//

import UIKit


final class ChatViewController: UIViewController {

    //temporary for debug
    var temparr: [MessageViewModel] = []
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .background.style(.firstLevel)()
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
        tableView.register(LeftTextMessageTableViewCell.self, forCellReuseIdentifier: LeftTextMessageTableViewCell.reuseIdentifier)
        tableView.register(RightTextMessageTableViewCell.self, forCellReuseIdentifier: RightTextMessageTableViewCell.reuseIdentifier)
        tableView.register(RightImageMessageTableViewCell.self, forCellReuseIdentifier: RightImageMessageTableViewCell.reuseIdentifier)
        tableView.register(LeftImageMessageTableViewCell.self, forCellReuseIdentifier: LeftImageMessageTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = .clear
        
        return tableView
    }()
    
    private var inputContainerView = InputView()
    
    private var inputViewBotttomConstrain: NSLayoutConstraint?
    private var inputViewHeightConstrain: NSLayoutConstraint?
    private var selectedIndexPath: IndexPath?
    private weak var selectedImageView: UIImageView?
    private var selectedContentFrameInCell: CGRect?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background.style(.accent)()
        //temp for debug
        temparr.append(contentsOf: MessageViewModel.testArray)
        
        setupInputContainer()
        setupTableView()
        
        tableView.dataSource = self
        tableView.delegate = self
        inputContainerView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tableView.scrollToBottom(isAnimated: false)
    }
    
    
    // MARK: - Interactions
    
    @objc
    private func handleKeyboardNotification(notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let difference = view.safeAreaInsets.bottom
        
        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
        
        inputViewBotttomConstrain?.constant =  isKeyboardShowing ? (-(keyboardViewEndFrame.height - difference)) : 0
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            
        }
        
    }
    
    // MARK: - UI setup
    
    private func setupInputContainer() {
        view.addSubview(inputContainerView)
        
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputContainerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            inputContainerView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        inputViewHeightConstrain = inputContainerView.heightAnchor.constraint(equalToConstant: 56)
        inputViewHeightConstrain?.isActive = true
        inputViewBotttomConstrain = NSLayoutConstraint(item: inputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(inputViewBotttomConstrain!)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
    }

}


// MARK: - TableViewDataSource

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temparr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageCellFactory.createCell(message: temparr[indexPath.row], tableView: tableView, indexPath: indexPath, hostingController: self)
        cell.selectionStyle = .none
        cell.configure(message: temparr[indexPath.row])
        
        return cell
    }

}

// MARK: - TableViewDelegate

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inputContainerView.dismissView()
    }
}

// MARK: - ChatCellDelegate

extension ChatViewController: ChatCellDelegate {
    func selectedContentInCell(content: UIImageView, contentFrameInCell: CGRect, indexPath: IndexPath) {
        selectedImageView = content
        selectedIndexPath = indexPath
        selectedContentFrameInCell = contentFrameInCell
        
        let photoController = PhotoZoomViewController()
        photoController.image = content.image
        
        let nav = self.navigationController
        nav?.delegate = photoController.transitionController
        
        photoController.transitionController.fromDelegate = self
        photoController.transitionController.toDelegate = photoController
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(photoController, animated: true)
    }
    
}


// MARK: - InputViewDelegate

extension ChatViewController: InputViewDelegate {
    func messageSent(messageViewModel: MessageViewModel) {
        temparr.append(messageViewModel)
        tableView.insertRows(at: [IndexPath(row: temparr.count - 1, section: 0)], with: .bottom)
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        tableView.scrollToRow(at: IndexPath(row: lastRowIndex, section: lastSectionIndex), at: .bottom, animated: true)
    }
    
    func inputViewHeightDidChange(heightConstrain: CGFloat) {
        inputViewHeightConstrain?.constant = heightConstrain
    }
}


// MARK: - ZoomAnimatorDelegate

extension ChatViewController: ZoomAnimatorDelegate {
    
    func transitionWillStartWith(zoomAnimator: ZoomAnimator) { }
    
    func transitionDidEndWith(zoomAnimator: ZoomAnimator) {
    }
    
    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView? {
        guard let image = selectedImageView else { return nil }
        
        return image
    }
    
    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ZoomAnimator) -> CGRect? {
        guard let indexPath = selectedIndexPath,
              let rawFrame = selectedContentFrameInCell
        else {
            return nil
        }
        
        let rectOfCellInTableView = tableView.rectForRow(at: indexPath)
        let rectOfCellInSuperview = tableView.convert(rectOfCellInTableView, to: tableView.superview)
        let correctOriginPoint = CGPoint(x: rawFrame.origin.x, y: rectOfCellInSuperview.origin.y + rawFrame.origin.y)
        let finalFrame = CGRect(origin: correctOriginPoint, size: rawFrame.size)
        
        return finalFrame
    }
    
}
