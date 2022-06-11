//
//  Login2ViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 06.02.2022.
//

import UIKit
import HSESKIT

final class LoginViewController: UIViewController, LoginScreen {
    // TODO: create custom buttons, textfield and move them to HSESHKIT package
    private lazy var loginButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Log In", for: .normal)
        button.setColors(.primary.style(.primary)(), .primary.style(.onPrimary)())
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)

        return button
    }()

    private let loginProblemButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setColors(.clear, .primary.style(.primary)())
        button.setTitle("Can't login ?", for: .normal)

        return button
    }()

    private let emailTextField: PrimaryTextField = {
        let textField = PrimaryTextField()
        textField.placeholder = "HSE Email"
        textField.setColors(.background.style(.accent)())
        textField.tag = 0
        textField.textContentType = .emailAddress
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.applyCustomClearButton()

        return textField
    }()

    private let passwordTextField: PrimaryTextField = {
        let textField = PrimaryTextField()
        textField.placeholder = "Password"
        textField.setColors(.background.style(.accent)())
        textField.tag = 1
        textField.isSecureTextEntry = true
        textField.applySecureEntrySwitcher()
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
        control.textFont = .customFont.style(.body)()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.heightAnchor.constraint(equalToConstant: 36).isActive = true

        return control
    }()
    private var activityAnimation: ActivityAnimationScreen
    private let mainView = UIView()
    private var passwordTextFieldFrameInWindow: CGRect?
    private var viewModel: LoginLogic?
    public var isAnimating: Bool = false {
        didSet {
            if(isAnimating) {
                activityAnimation.isHidden = false
                activityAnimation.isAnimating = true
            } else {
                activityAnimation.isHidden = true
                activityAnimation.isAnimating = false
            }
        }
    }
    
    // MARK: - Init
    init() {
        self.activityAnimation = ActivityAnimationScreen(
            colors: [.primary.style(.primary)(), .primary.style(.filler)()],
            lineWidth: 5
        )
        super.init(nibName: nil, bundle: nil)
        self.viewModel = LoginViewModel(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .background.style(.firstLevel)()

        setup()
        emailTextField.delegate = self
        passwordTextField.delegate = self

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willShowKeyboard),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(willHideKeyboard),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        viewModel = LoginViewModel(self)
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
        setupActivityAnimation()
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
            buttonSV.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -24)
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
    
    private func setupActivityAnimation() {
        self.view.addSubview(activityAnimation)
        
        activityAnimation.pin(to: view)
        
        activityAnimation.isHidden = true
    }
    
    // MARK: - Warning Activity
    public func showIncorrectDataWarning() {
        emailTextField.layer.borderColor = UIColor.red.cgColor
        emailTextField.layer.borderWidth = 1.5
        passwordTextField.layer.borderColor = UIColor.red.cgColor
        passwordTextField.layer.borderWidth = 1.5
    }
    
    private func resetWarningView() {
        emailTextField.layer.borderWidth = 0
        passwordTextField.layer.borderWidth = 0
    }

    // MARK: - Interactions
    @objc
    private func handleTap() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    @objc
    private func loginButtonPressed() {
        let roleNumber = segmentControll.selectedSegmentIndex
        viewModel?.loginButtonPressed(emailTextField.text, passwordTextField.text, roleNumber)
    }

    // MARK: - Keyboard Notifications
    @objc
    private func willShowKeyboard(notification: NSNotification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }
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
        } else if textField.tag == 1 {
            loginButtonPressed()
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.resetWarningView()
    }
}
