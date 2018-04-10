//
//  LogInController.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 01.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import UIKit

class LogInController: UIViewController {
    
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signButton: UIButton!
    
    let userService = DIContainer.container.resolve(UserServices.self)!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signButton.layer.cornerRadius = 10
    }

    @IBAction func signInPressed(_ sender: Any) {
        
        let username = loginTextField.text!
        let password = passwordTextField.text!
        
        if username.isEmpty || password.isEmpty {
            shakeButton()
            return
        }
        doLogin(usr: username, psw: password)
    }
    
    func doLogin(usr: String, psw: String) {
        signButton.isEnabled = false
        
        userService.login(username: usr, password: psw).done {
            self.loginComplete()
        }.catch {_ in 
            self.wrongData()
            self.signButton.isEnabled = true
        }
    }
    
    func shakeButton() {
        loginTextField.shakeAnimation(duration: 0.07, repeatCount: 2)
        passwordTextField.shakeAnimation(duration: 0.07, repeatCount: 2)
    }
    
    func wrongData() {
        UIView.animate(withDuration: 0.1, animations: {
            self.signButton.backgroundColor = .red
        }) { (true) in
            UIView.animate(withDuration: 0.4, delay: 0.3, options: .curveEaseOut, animations: {
                self.signButton.backgroundColor = UIColor(red: 63/255, green: 144/255, blue: 155/255, alpha: 1)
            })
        }
    }
    
    func loginComplete() {
        UIView.animate(withDuration: 0.3, animations: {
            self.signButton.backgroundColor = .green
            self.signButton.setTitle("Confirmed", for: .normal)
            }) { (true) in
                self.performSegue(withIdentifier: "GoToReposTable", sender: self)
        }
    }
}
