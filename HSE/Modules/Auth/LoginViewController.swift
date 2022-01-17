//
//  LoginViewController.swift
//  HSE
//
//  Created by Дмитрий Соколов on 13.01.2022.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 8
        
        emailTextField.layer.cornerRadius = 8
        emailTextField.layer.masksToBounds = true
        emailTextField.layer.borderWidth = 0
        emailTextField.placeholder = "HSE Email"
        emailTextField.backgroundColor = .background.style(.accent)()
        emailTextField.setLeftPaddingPoints(16)

        passwordTextField.layer.cornerRadius = 8
        passwordTextField.layer.masksToBounds = true
        passwordTextField.layer.borderWidth = 0
        passwordTextField.placeholder = "Password"
        passwordTextField.backgroundColor = .background.style(.accent)()
        passwordTextField.setLeftPaddingPoints(16)
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap) // Add gesture recognizer to background view
    }
    
    @objc func handleTap()
    {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func SegmentValueChanged(_ sender: CustomSegmentedController) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Student")
        case 1:
            print("TA")
        case 2:
            print("Professor")
        default:
            print("hz")
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        let tabVC = TabBarBaseController()
        tabVC.modalPresentationStyle = .fullScreen
        present(tabVC, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
