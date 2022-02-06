//
//  Login2ViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 06.02.2022.
//

import UIKit

class Login2ViewController: UIViewController {
    
    private var loginButton: UIButton = {
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
    
    private var loginProblemButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .primary.style(.primary)()
        button.setTitle("Can't login ?", for: .normal)
        button.setTitleColor(.primary.style(.primary)(), for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        return button
    }()
    
    private var emailTextField: UITextField = {
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
        
        return textField
    }()
    
    private var passwordTextField: UITextField = {
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
        
        return textField
    }()
    
    private var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "HseLogo"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var buttonSV: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 16
        
        return stackView
    }()
    
    private var formSV: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 16
        
        return stackView
    }()
    
// MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setup()
    }
    
// MARK: - UI setup
    
    private func setup() {
        setupButtons()
    }
    
    private func setupButtons() {
        buttonSV.addArrangedSubview(loginProblemButton)
        buttonSV.addArrangedSubview(loginButton)
        
        view.addSubview(buttonSV)
        
        buttonSV.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            buttonSV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            buttonSV.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            buttonSV.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
        ])
    }
    
    private func setupForm() {
        formSV.addArrangedSubview(emailTextField)
        formSV.addArrangedSubview(passwordTextField)
        
        
    }
    
// MARK: - Interactions
    
    @objc
    private func loginButtonPressed() {
        let tabVC = TabBarBaseController()
        tabVC.modalPresentationStyle = .fullScreen
        present(tabVC, animated: true, completion: nil)
    }

}
