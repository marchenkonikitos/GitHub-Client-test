//
//  LogInController.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 01.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import UIKit
import Alamofire
import Locksmith

class LogInController: UIViewController {
    
    @IBOutlet var loginTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signButton.layer.cornerRadius = 10

        if let accountData = try Locksmith.loadDataForUserAccount(userAccount: "Account") {
            let username = accountData["username"] as! String
            let password = accountData["password"] as! String
            loginTextField.text = username
            passwordTextField.text = password
            
            doLogin(usr: username, psw: password)
        }
    }

    @IBAction func signInPressed(_ sender: Any) {
        
        let username = loginTextField.text
        let password = passwordTextField.text
        
        if (username == "" || password == "") {
            shakeButton()
            return
        }
        do {
            try Locksmith.saveData(data: ["username" : username, "password" : password], forUserAccount: "Account")
        } catch {
            print("Unable to save data")
        }
        doLogin(usr: username!, psw: password!)
        
    }
    
    func doLogin(usr: String, psw: String) {
        signButton.isEnabled = false
        
        let url = URL(string: "https://api.github.com/user")
        
        let credentialData = "\(usr):\(psw)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(url!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
        .validate()
            .responseJSON { responce in
                if responce.result.value != nil {
                    let data = responce.data
                    do {
                        let userData = try JSONDecoder().decode(UserData.self, from: data!)
                        self.saveData(userData: userData)
                        self.loginComplete()
                    } catch {
                    }
                } else {
                    self.shakeButton()
                    self.wrongData()
                }
        }
    }
    
    func shakeButton() {
        let animation1 = CABasicAnimation(keyPath: "position")
        animation1.duration = 0.07
        animation1.repeatCount = 2
        animation1.autoreverses = true
        animation1.fromValue = NSValue(cgPoint: CGPoint(x: loginTextField.center.x - 5, y: loginTextField.center.y))
        animation1.toValue = NSValue(cgPoint: CGPoint(x: loginTextField.center.x + 5, y: loginTextField.center.y))
        
        loginTextField.layer.add(animation1, forKey: "position")
        
        let animation2 = CABasicAnimation(keyPath: "position")
        animation2.duration = 0.07
        animation2.repeatCount = 2
        animation2.autoreverses = true
        animation2.fromValue = NSValue(cgPoint: CGPoint(x: passwordTextField.center.x - 5, y: passwordTextField.center.y))
        animation2.toValue = NSValue(cgPoint: CGPoint(x: passwordTextField.center.x + 5, y: passwordTextField.center.y))
        
        passwordTextField.layer.add(animation2, forKey: "position")
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
    
    func saveData (userData: UserData) {
        UserDefaults.standard.set(userData.id, forKey: "userId")
        UserDefaults.standard.set(userData.avatar_url, forKey: "avatar_url")
        UserDefaults.standard.set(userData.login, forKey: "login")
        UserDefaults.standard.set(userData.gists_url, forKey: "userUrl")
        UserDefaults.standard.set(userData.gists_url, forKey: "gists_url")
        UserDefaults.standard.set(userData.repos_url, forKey: "repos_url")
        UserDefaults.standard.set(userData.name, forKey: "userName")
        UserDefaults.standard.set(userData.public_repos, forKey: "numberOfRepos")
    }

}

