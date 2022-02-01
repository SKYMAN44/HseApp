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
        button.widthAnchor.constraint(equalToConstant: 36).isActive = true
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        
        return button
    }()
    
    
    private var chooseImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
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
        button.widthAnchor.constraint(equalToConstant: 36).isActive = true
        button.addTarget(self, action: #selector(chooseImageTapped(sender:)), for: .touchUpInside)
        
        return button
    }()
    
    private var inputTextView: UITextView = {
        let textField = UITextView()
        textField.backgroundColor = .background.style(.firstLevel)()
        textField.textColor = .textAndIcons.style(.tretiary)()
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0
        textField.contentInsetAdjustmentBehavior = .never
        textField.isEditable = true
        textField.text = "Message"
        textField.font = .customFont.style(.body)()
        textField.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        textField.isScrollEnabled = false
        
        return textField
    }()
    
    private var inputViewBotttomConstrain: NSLayoutConstraint?
    private var inputViewHeightConstrain: NSLayoutConstraint?
    
    
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
        inputTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        tableView.scrollToBottom(isAnimated: false)
    }
    
    override func viewDidLayoutSubviews() {
        sendButton.clipsToBounds = true
        sendButton.layer.cornerRadius = sendButton.frame.width / 2
        chooseImageButton.clipsToBounds = true
        chooseImageButton.layer.cornerRadius = sendButton.frame.width / 2
    }
    
    
    // MARK: Interactions
    
    @objc
    private func sendButtonTapped() {
        guard let text = inputTextView.text, inputTextView.text != "" else {return}
        inputTextView.text = ""
    
        let message = MessageViewModel(side: .right, type: .text, text: text, imageURL: nil)
        temparr.append(message)
        // temp for fun
        
        if(!testImageArr.isEmpty) {
            var images: [MessageViewModel] = []
            for item in testImageArr {
                var model = MessageViewModel(side: .right, type: .image, text: nil, imageURL: URL(string: "sss"))
                model.imageArray = item
                images.append(model)
            }
            temparr.append(contentsOf: images)
            testImageArr.removeAll()
        }
        
        tableView.reloadData()

        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        tableView.scrollToRow(at: IndexPath(row: lastRowIndex, section: lastSectionIndex), at: .bottom, animated: true)
    }
    
    @objc
    private func chooseImageTapped(sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alertController = UIAlertController(title:"Choose Image Source", message: nil,preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel",style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let cameraAction = UIAlertAction(title: "Camera",style: .default, handler: { action in imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library",style: .default, handler: { action in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
        alertController.addAction(photoLibraryAction)
        }
        
        alertController.popoverPresentationController?.sourceView = sender
        
        present(alertController, animated: true, completion: nil)
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
        view.addSubview(messageInputContainerView)
        
        messageInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            messageInputContainerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            messageInputContainerView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
        
        inputViewHeightConstrain = messageInputContainerView.heightAnchor.constraint(equalToConstant: 56)
        inputViewHeightConstrain?.isActive = true
        inputViewBotttomConstrain = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(inputViewBotttomConstrain!)
        
        view.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            sendButton.rightAnchor.constraint(equalTo: messageInputContainerView.rightAnchor, constant: -10),
            sendButton.bottomAnchor.constraint(equalTo: messageInputContainerView.bottomAnchor, constant: -10)
        ])
        
        view.addSubview(chooseImageButton)
        
        NSLayoutConstraint.activate([
            chooseImageButton.leftAnchor.constraint(equalTo: messageInputContainerView.leftAnchor, constant: 10),
            chooseImageButton.bottomAnchor.constraint(equalTo: messageInputContainerView.bottomAnchor, constant: -10)
        ])
        
        view.addSubview(inputTextView)
        
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputTextView.leftAnchor.constraint(equalTo: chooseImageButton.rightAnchor, constant: 10),
            inputTextView.topAnchor.constraint(equalTo: messageInputContainerView.topAnchor, constant: 10),
            inputTextView.bottomAnchor.constraint(equalTo: messageInputContainerView.bottomAnchor, constant: -10),
            inputTextView.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -8)
        ])
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
    
    // remove
    var testImageArr: [UIImage] = []

}


// MARK: - TableViewDataSource

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temparr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MessageCellFactory.createCell(message: temparr[indexPath.row], tableView: tableView, indexPath: indexPath)
        
        cell.selectionStyle = .none
        cell.configure(message: temparr[indexPath.row])
        
        return cell
    }

}

// MARK: - TableViewDelegate

extension ChatViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inputTextView.resignFirstResponder()
    }
}

// MARK: - TextViewDelegate

extension ChatViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        sendButton.isEnabled = true
        if(textView.textColor == .textAndIcons.style(.tretiary)()) {
            if(testImageArr.isEmpty) {
                textView.text = nil
            }
            textView.textColor = .textAndIcons.style(.primary)()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text.isEmpty || textView.text == "") {
            sendButton.isEnabled = false
            textView.text = "Message"
            textView.textColor = .textAndIcons.style(.tretiary)()
            inputViewHeightConstrain?.constant = 56
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let height = newSize.height
        if(height > 100) {
            inputViewHeightConstrain?.constant = 150
            inputTextView.isScrollEnabled = true
        } else {
            inputTextView.isScrollEnabled = false
            inputViewHeightConstrain?.constant = height + 20
        }
    }
}

extension ChatViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        let attachment = NSTextAttachment()
        attachment.image = selectedImage
        testImageArr.append(selectedImage)
            //calculate new size.  (-20 because I want to have a litle space on the right of picture)
        let newImageWidth = 70.0
        let newImageHeight = 70.0
            //resize this
        attachment.bounds = CGRect.init(x: 0, y: 0, width: newImageWidth, height: newImageHeight)
            //put your NSTextAttachment into and attributedString
        let attString = NSAttributedString(attachment: attachment)
            //add this attributed string to the current position.
        inputTextView.textStorage.insert(attString, at: 0)
        
        dismiss(animated: true, completion: nil)
    }
}

