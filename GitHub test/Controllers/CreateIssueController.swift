//
//  CreateIssueController.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 02.04.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import UIKit

class CreateIssueController: UIViewController {
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var bodyField: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    var issueService = IssuesService()
    var repository: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        buttonDesign()
        
    }
    
    func buttonDesign() {
        submitButton.layer.cornerRadius = submitButton.frame.size.height /  2
    }

    @IBAction func buttonPressed(_ sender: Any) {
        if !emptyFields() {
            issueService.createIssue(title: titleField.text!, body: bodyField.text!, repository: repository).done {
                self.navigationController?.popViewController(animated: true)
                }.catch { error in
                    let alert = UIAlertController(title: "Problem", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                    
                    self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Empty field", message: "Fill all fields, please", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func emptyFields() -> Bool{
        if titleField.text == "" || bodyField.text == "" {
            return true
        }
        return false
    }
}
