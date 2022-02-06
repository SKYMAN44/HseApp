//
//  Login2ViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 06.02.2022.
//

import UIKit

final class LoginViewController: UIViewController {
    private let loginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .primary.style(.primary)()
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.primary.style(.onPrimary)(), for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    private let loginProblemButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setTitle("Can't login ?", for: .normal)
        button.setTitleColor(.primary.style(.primary)(), for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        return button
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0
        textField.placeholder = "HSE Email"
        textField.backgroundColor = .background.style(.accent)()
        textField.setLeftPaddingPoints(16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        textField.tag = 0
        textField.textContentType = .emailAddress
        
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.layer.cornerRadius = 8
        textField.layer.masksToBounds = true
        textField.layer.borderWidth = 0
        textField.placeholder = "Password"
        textField.backgroundColor = .background.style(.accent)()
        textField.setLeftPaddingPoints(16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 48).isActive = true
        textField.tag = 1
        textField.isSecureTextEntry = true
        textField.textContentType = .password
        
        return textField
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "HseLogo"))
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()
    
    private let buttonSV: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 16
        
        return stackView
    }()
    
    private let formSV: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 16
        
        return stackView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isMultipleTouchEnabled = true
        
        return scrollView
    }()
    
    private let segmentControll: SegmentedControl = {
        let control = SegmentedControl()
        control.titlesCS = "Student,Assistant,Professor"
        control.textColor = .textAndIcons.style(.secondary)()
        control.selectorColor = .primary.style(.filler)()
        control.selectorTextColor = .primary.style(.primary)()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        return control
    }()
    
    private let mainView = UIView()
    private var passwordTextFieldFrameInWindow: CGRect?
    
// MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .background.style(.firstLevel)()
        
        setup()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let passwordTextFieldFrameFirstLevel = formSV.convert(passwordTextField.frame, to: mainView)
        passwordTextFieldFrameInWindow = mainView.convert(passwordTextFieldFrameFirstLevel, to: view.window)
    }
    
// MARK: - UI setup
    
    private func setup() {
        setupScroll()
        setupButtons()
        setupForm()
    }
    
    private func setupScroll() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        scrollView.addSubview(mainView)
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            mainView.leftAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.rightAnchor),
            mainView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            mainView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    
    private func setupButtons() {
        buttonSV.addArrangedSubview(loginProblemButton)
        buttonSV.addArrangedSubview(loginButton)
        
        mainView.addSubview(buttonSV)
        
        buttonSV.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonSV.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -24),
            buttonSV.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 24),
            buttonSV.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -24),
        ])
    }
    
    private func setupForm() {
        formSV.addArrangedSubview(segmentControll)
        formSV.addArrangedSubview(emailTextField)
        formSV.addArrangedSubview(passwordTextField)
        
        mainView.addSubview(logoImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.topAnchor, constant: 24),
            logoImageView.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 24),
            logoImageView.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -24),
            logoImageView.heightAnchor.constraint(equalToConstant: 240)
        ])
        
        mainView.addSubview(formSV)
        
        formSV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            formSV.topAnchor.constraint(equalTo: logoImageView.bottomAnchor),
            formSV.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -24),
            formSV.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 24)
        ])
        
        
    }
    
// MARK: - Interactions
    
    @objc
    func handleTap() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @objc
    private func loginButtonPressed() {
        let tabVC = TabBarBaseController()
        tabVC.modalPresentationStyle = .fullScreen
        present(tabVC, animated: true, completion: nil)
    }
    
    @objc
    private func willShowKeyboard(notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let yDifference = keyboardViewEndFrame.minY - passwordTextFieldFrameInWindow!.maxY
        // if difference is positive => keyboard not intersecting with textfield
        guard yDifference < 0 else { return }
        scrollView.setContentOffset(CGPoint(x: 0, y: -yDifference + 10), animated: true)
    }
    
    @objc
    private func willHideKeyboard(notification: NSNotification) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }

}

// MARK: - TextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        }
        else if (textField.tag == 1) {
            loginButtonPressed()
        }
        else {
            textField.resignFirstResponder()
        }
        return false
    }
    
}
