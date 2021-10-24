//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Omar Zakaria on 06/10/2021.
//

import UIKit

class LoginViewController: UIViewController , UITextFieldDelegate {
    
    // probably will create a custom error enum
    
    // MARK: -IBOultets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    let urlSignUp = ClientUdacity.Endpoints.SignUpUdacity.url
    
    var isEmaiTextFieldEmpty = true
    var isPasswordTextFieldEmpty = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.text = ""
        passwordTextField.text = ""
        emailTextField.delegate = self
        passwordTextField.delegate = self
        enableButton(false , button: loginButton)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    // MARK: -IBFunctions
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        loggingIn(true)
        ClientUdacity.login(email: self.emailTextField.text ?? "" , password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success: error:))
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        loggingIn(true)
        UIApplication.shared.open(urlSignUp, options: [:], completionHandler: nil)
//        print("Sign up button pressed")
    }
    
    
    func handleLoginResponse(success: Bool, error: Error?){
        loggingIn(false)
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "login", sender: nil)
            }
        } else {
            showAlert(message: "Invalid username or password ", title: "Error Logging In")
//            showAlert(message: "Error Logging In", title: "Ok")
            
        }
        
    }
    
    
    // MARK: -Think of a name
    func loggingIn(_ loggingIn :Bool){
        if loggingIn{
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.enableButton(false, button: self.loginButton)
            }
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.enableButton(false, button: self.loginButton)
            }
        }
        DispatchQueue.main.async {
            self.emailTextField.isEnabled = !loggingIn
            self.passwordTextField.isEnabled = !loggingIn
            self.loginButton.isEnabled = !loggingIn
            self.signUpButton.isEnabled = !loggingIn
        }
    }
    
    // MARK: -Think of another name
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextField{
            let currentText = emailTextField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else {return false}
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.isEmpty && updatedText == "" {
                isEmaiTextFieldEmpty = true
            } else {
                isEmaiTextFieldEmpty = false
            }
        }
        
        if textField ==  passwordTextField{
            let currentText = passwordTextField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else {return false}
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.isEmpty &&  updatedText == ""{
                isPasswordTextFieldEmpty = true
            } else {
                isPasswordTextFieldEmpty = false
            }
        }
        
        if isEmaiTextFieldEmpty == false &&  isPasswordTextFieldEmpty == false {
            enableButton(true, button: loginButton)
        } else {
            enableButton(false , button: loginButton)
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        enableButton(false , button: loginButton)
        if textField == emailTextField{
            isEmaiTextFieldEmpty = true
        }
        if textField == passwordTextField{
            isPasswordTextFieldEmpty = true
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField{
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            loginButtonPressed(loginButton)
        }
        return true
    }
    
}



