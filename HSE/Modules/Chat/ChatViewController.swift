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
    
//    @objc
//    private func chooseImageTapped(sender: UIButton) {
//        let imagePicker = UIImagePickerController()
//        imagePicker.delegate = self
//        let alertController = UIAlertController(title:"Choose Image Source", message: nil,preferredStyle: .actionSheet)
//
//        let cancelAction = UIAlertAction(title: "Cancel",style: .cancel, handler: nil)
//        alertController.addAction(cancelAction)
//
//        if UIImagePickerController.isSourceTypeAvailable(.camera)
//        {
//            let cameraAction = UIAlertAction(title: "Camera",style: .default, handler: { action in imagePicker.sourceType = .camera
//            self.present(imagePicker, animated: true, completion: nil)
//            })
//            alertController.addAction(cameraAction)
//        }
//
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            let photoLibraryAction = UIAlertAction(title: "Photo Library",style: .default, handler: { action in
//                imagePicker.sourceType = .photoLibrary
//                self.present(imagePicker, animated: true, completion: nil)
//            })
//        alertController.addAction(photoLibraryAction)
//        }
//
//        alertController.popoverPresentationController?.sourceView = sender
//
//        present(alertController, animated: true, completion: nil)
//    }
    
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
    
    // remove
    var testImageArr: [UIImage] = []

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


// MARK: - InputViewDelegate

extension ChatViewController: InputViewDelegate {
    func messageSent(messageViewModel: MessageViewModel) {
        temparr.append(messageViewModel)
        tableView.reloadData()
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        tableView.scrollToRow(at: IndexPath(row: lastRowIndex, section: lastSectionIndex), at: .bottom, animated: true)
    }
    
    func inputViewHeightDidChange(heightConstrain: CGFloat) {
        inputViewHeightConstrain?.constant = heightConstrain
    }
}

// MARK: - ChatCellDelegate

extension ChatViewController: chatCellDelegate {
    func selectedContentInCell(content: UIImageView, indexPath: IndexPath) {
        selectedImageView = content
        selectedIndexPath = indexPath
        let photoController = PhotoZoomViewController()
        photoController.image = content.image
        let nav = self.navigationController
//        nav?.delegate = photoController.transitionController
//        photoController.transitionController.fromDelegate = self
        photoController.transitionController.toDelegate = photoController
        self.navigationController?.pushViewController(photoController, animated: true)
    }
    
    
}



