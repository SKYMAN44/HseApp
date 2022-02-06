//
//  Login2ViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 06.02.2022.
//

import UIKit

final class LoginViewController: UIViewController {
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
        button.backgroundColor = .clear
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
        textField.placeholder = "Password"
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
    
    private var segmentControll: SegmentedControl = {
        let control = SegmentedControl()
        control.titlesCS = "Student,Assistant,Professor"
        control.textColor = .textAndIcons.style(.secondary)()
        control.selectorColor = .primary.style(.filler)()
        control.selectorTextColor = .primary.style(.primary)()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.heightAnchor.constraint(equalToConstant: 36).isActive = true
        
        return control
    }()
    
// MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .background.style(.firstLevel)()
        
        setup()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
// MARK: - UI setup
    
    private func setup() {
        setupButtons()
        setupForm()
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
        formSV.addArrangedSubview(segmentControll)
        formSV.addArrangedSubview(emailTextField)
        formSV.addArrangedSubview(passwordTextField)
        
        view.addSubview(logoImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            logoImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            logoImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            logoImageView.heightAnchor.constraint(equalToConstant: 240)
        ])
        
        view.addSubview(formSV)
        
        formSV.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            formSV.topAnchor.constraint(equalTo: logoImageView.bottomAnchor),
            formSV.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            formSV.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24)
//            formSV.bottomAnchor.constraint(lessThanOrEqualTo: buttonSV, constant: -)
        ])
        
        
    }
    
// MARK: - Interactions
    
    @objc func handleTap() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @objc
    private func loginButtonPressed() {
        let tabVC = TabBarBaseController()
        tabVC.modalPresentationStyle = .fullScreen
        present(tabVC, animated: true, completion: nil)
    }

}

// MARK: - TextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
