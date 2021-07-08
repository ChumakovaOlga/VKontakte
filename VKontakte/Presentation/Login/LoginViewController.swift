
//  LoginViewController.swift
//  VKontakte
//  Created by Olga Chumakova on 04.07.2021.


import UIKit

final class LoginViewController: UIViewController {
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var titleImageView: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var loginLabel: UILabel!
    @IBOutlet private weak var loginTextField: UITextField!
    @IBOutlet private weak var passwordLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        //Второе - когда она пропадает
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //Отписываемся от уведомлений о клавиатуре
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
           if identifier == "moveToMain" {
            //Получаем текст логина
            guard
                let login = loginTextField.text,
                let password = passwordTextField.text
            else {
                print("Login or password are equal nil")
                showErrorAlert(message: "nothing is written")
                return false
            }
            
            //Проверяем, верны ли они
            if login == "1" && password == "1" {
                print("authorization succeeded")
                return true
            } else {
                showErrorAlert(message: "empty fields or wrong login or password ")
                print("authorization failed")
                return false
            }
        }
        showErrorAlert(message: "wrong segue identifier")
        return false
    }
    
    @IBAction private func loginButtonPressed(_ sender: UIButton) {
        print("loginButtonPressed")
    }
    //Когда клавиатура появляется
    
    @objc private func keyboardWasShown(notification: Notification) {
        //Получаем размер клавиатуры
        
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        
        //Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    //Когда клавиатура исчезает
    
    @objc private func keyboardWillBeHidden(notification: Notification) {
        //Устанавливаем отступ внизу UIScrollView, равный 0
        
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    @objc private func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    private func setViews() {
        loginLabel.text = "Login"
        passwordLabel.text = "Password"

        loginButton.setTitle("Log in", for: .normal)
        loginButton.layer.cornerRadius = 8
        loginButton.backgroundColor = .gray
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
    }
    //создание alert
    private func showErrorAlert(message: String) {
        
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .cancel) {_ in
            self.loginTextField.text = ""
            self.passwordTextField.text = ""
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
}
