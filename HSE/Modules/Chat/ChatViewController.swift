//
//  ChatViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 28.01.2022.
//

import UIKit


var temparr: [Message] = []

final class ChatViewController: UIViewController {

    private var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .background.style(.firstLevel)()
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = .clear
        
        return tableView
    }()
    
    private var messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .background.style(.accent)()
        
        return view
    }()
    
    private var sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "upwardArrow"), for: .normal)
        button.tintColor = .background.style(.firstLevel)()
        button.backgroundColor = .primary.style(.primary)()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addConstraint(NSLayoutConstraint(item: button,
                                                  attribute: .height,
                                                  relatedBy: .equal,
                                                  toItem: button,
                                                  attribute: .width,
                                                  multiplier: 1,
                                                  constant: 0))
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private var inputTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0
        textField.placeholder = "Message"
        textField.backgroundColor = .background.style(.firstLevel)()
        textField.setLeftPaddingPoints(16)
        
        return textField
    }()
    
    private var inputViewBotttomConstrain: NSLayoutConstraint?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.backgroundColor = .background.style(.accent)()
        self.tabBarController?.tabBar.isHidden = true
        
        //temp for debug
        temparr.append(contentsOf: Message.array)
        
        setupInputContainer()
        
        setupTableView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        sendButton.clipsToBounds = true
        sendButton.layer.cornerRadius = sendButton.frame.width / 2
    }
    
    @objc
    private func sendButtonTapped() {
        guard let text = inputTextField.text else {return}
        inputTextField.text = ""
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let timeString = "\(hour):\(minutes)"
        let message = Message(senderName: "Dima", senderType: .right, message: text, attachment: nil, time: timeString)
        temparr.append(message)
        tableView.reloadData()
        
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        tableView.scrollToRow(at: IndexPath(row: lastRowIndex, section: lastSectionIndex), at: .bottom, animated: true)
    }
    
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
        let stackView = UIStackView(arrangedSubviews: [inputTextField, sendButton])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        messageInputContainerView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: messageInputContainerView.topAnchor, constant: 10),
            stackView.leftAnchor.constraint(equalTo: messageInputContainerView.leftAnchor, constant: 10),
            stackView.rightAnchor.constraint(equalTo: messageInputContainerView.rightAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: messageInputContainerView.bottomAnchor, constant: -10)
        ])
        
        
        view.addSubview(messageInputContainerView)
        
        messageInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageInputContainerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            messageInputContainerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            messageInputContainerView.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        inputViewBotttomConstrain = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        
        view.addConstraint(inputViewBotttomConstrain!)
        
        sendButton.layer.cornerRadius = sendButton.frame.height / 2
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageInputContainerView.topAnchor),
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
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.reuseIdentifier) as! MessageTableViewCell
        cell.selectionStyle = .none
        cell.configure(message: temparr[indexPath.row])
        
        return cell
    }
    
    
}

// MARK: - TableViewDelegate

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
}

