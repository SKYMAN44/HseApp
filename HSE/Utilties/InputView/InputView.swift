//
//  InputView.swift
//  HSE
//
//  Created by Дмитрий Соколов on 03.02.2022.
//

import UIKit

protocol InputViewDelegate {
    func inputViewHeightDidChange(heightConstrain: CGFloat)
    func messageSent(messageViewModel: MessageViewModel)
}

class InputView: UIView {
    
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
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0
        textField.contentInsetAdjustmentBehavior = .never
        textField.isEditable = true
        textField.text = "Message"
        textField.font = .customFont.style(.message)()
        textField.textContainerInset = UIEdgeInsets(top: 3, left: 5, bottom: 3, right: 5)
        textField.isScrollEnabled = false
        
        return textField
    }()
    
    
    private var inputFieldView: UIView = {
        let view = UIView()
        view.backgroundColor = .background.style(.firstLevel)()
        view.layer.cornerRadius = 12
        
        return view
    }()
    
    private var contentCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 70, height: 70)
        layout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(InputContentCollectionViewCell.self, forCellWithReuseIdentifier: InputContentCollectionViewCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        return collectionView
    }()
    
    
    var delegate: InputViewDelegate?
    var presentingController: UIViewController?
    var chosenPhotos: [UIImage] = [] {
        didSet {
            if(chosenPhotos.isEmpty) {
                contentCollectionView.isHidden = true
            } else {
                contentCollectionView.isHidden = false
                contentCollectionView.reloadData()
                textViewDidChange(inputTextView)
            }
        }
    }
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        inputTextView.delegate = self
        contentCollectionView.delegate = self
        contentCollectionView.dataSource = self
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        presentingController = findViewController()
        sendButton.layer.cornerRadius = sendButton.frame.width / 2
        chooseImageButton.layer.cornerRadius = chooseImageButton.frame.width / 2
    }
    
    // MARK: - UI setup
    
    private func setup() {
        setupButtons()
        setupInputField()
    }
    
    private func setupButtons() {
        addSubview(sendButton)
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sendButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        addSubview(chooseImageButton)
        
        NSLayoutConstraint.activate([
            chooseImageButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            chooseImageButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    private func setupInputField() {
        addSubview(inputFieldView)
        
        inputFieldView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            inputFieldView.leftAnchor.constraint(equalTo: chooseImageButton.rightAnchor, constant: 10),
            inputFieldView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            inputFieldView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            inputFieldView.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -8)
        ])
        
        let stackView = UIStackView(arrangedSubviews: [contentCollectionView, inputTextView])
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 5
        
        inputFieldView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: inputFieldView.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: inputFieldView.bottomAnchor, constant: -5),
            stackView.leftAnchor.constraint(equalTo: inputFieldView.leftAnchor, constant: 5),
            stackView.rightAnchor.constraint(equalTo: inputFieldView.rightAnchor, constant: -5)
        ])
        
        contentCollectionView.isHidden = true
    }
    
    // MARK: - Interactions
    
    @objc
    private func sendButtonTapped() {
        guard let text = inputTextView.text, inputTextView.text != "" else { return }
        inputTextView.text = ""
        let viewModel = MessageViewModel(side: .right, type: .text, text: text, imageURL: nil)
        delegate?.messageSent(messageViewModel: viewModel)
    }
    
    @objc
    private func chooseImageTapped(sender: UIButton) {
        guard let controller = presentingController else { return }
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let alertController = UIAlertController(title:"Choose Image Source", message: nil,preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "Cancel",style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            let cameraAction = UIAlertAction(title: "Camera",style: .default, handler: { action in imagePicker.sourceType = .camera
                controller.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library",style: .default, handler: { action in
                imagePicker.sourceType = .photoLibrary
                controller.present(imagePicker, animated: true, completion: nil)
            })
        alertController.addAction(photoLibraryAction)
        }

        alertController.popoverPresentationController?.sourceView = sender

        controller.present(alertController, animated: true, completion: nil)
    }

    
    // MARK: - API
    
    public func dismissView() {
        inputTextView.resignFirstResponder()
    }
    
}

// MARK: - CollectionViewDelegate

extension InputView: UICollectionViewDelegate { }

// MARK: - CollectionView Data Source

extension InputView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        chosenPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InputContentCollectionViewCell.reuseIdentifier, for: indexPath) as! InputContentCollectionViewCell
        cell.configure(image: chosenPhotos[indexPath.row])
        return cell
    }
    
}

// MARK: - TextViewDelegate

extension InputView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        sendButton.isEnabled = true
        if(textView.textColor == .textAndIcons.style(.tretiary)()) {
            textView.text = nil
            textView.textColor = .textAndIcons.style(.primary)()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text.isEmpty || textView.text == "") {
            sendButton.isEnabled = false
            textView.text = "Message"
            textView.textColor = .textAndIcons.style(.tretiary)()
            delegate?.inputViewHeightDidChange(heightConstrain: 56)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let height = newSize.height
        if(!chosenPhotos.isEmpty) {
            delegate?.inputViewHeightDidChange(heightConstrain: 150)
        } else if(height > 100) {
            delegate?.inputViewHeightDidChange(heightConstrain: 150)
            inputTextView.isScrollEnabled = true
        } else {
            inputTextView.isScrollEnabled = false
            delegate?.inputViewHeightDidChange(heightConstrain: 30 + height)
        }
    }
}

// MARK: - ImagePickerDelegate

extension InputView: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        guard let selectedImage = info[.originalImage] as? UIImage,
              let controller = presentingController
        else { return }
        chosenPhotos.append(selectedImage)
        
        controller.dismiss(animated: true, completion: nil)
    }
}



extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}
