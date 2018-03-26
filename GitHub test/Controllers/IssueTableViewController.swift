//
//  IssueTableViewController.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 06.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import UIKit

class IssueTableViewController: UITableViewController {
    
    var repository = Repository()
    var issuesArray: [Issues] = []
    let variable = Variables()
    let issueService = IssuesService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = repository.name
        self.title = title
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        let addButton = UIButton.init(type: .custom)
        addButton.setImage(UIImage(named: "add"), for: UIControlState.normal)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: addButton)
        self.navigationItem.rightBarButtonItem = barButton
        
        getData()
    }
    
    func getData() {
        issueService.getIssues(repository: repository, success: {
            self.issuesArray = self.issueService.loadIssues()
            self.tableView.reloadData()
        }, failed: { error in
            let alert = UIAlertController(title: "Problem", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            })
    }
    
    @objc
    func addButtonPressed() {
        self.performSegue(withIdentifier: "goToAddIssue", sender: self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return issuesArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "issueCell", for: indexPath) as! IssueTableViewCell
        
        if (issuesArray.count > 0) && (issuesArray.count > indexPath.row) {
            let issueForCell = issuesArray[indexPath.row]
            cell.initCell(issue: issueForCell)
        }

        return cell
    }
    
    var selectedIssue: Issues?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedIssue = issuesArray[indexPath.row]
        
        performSegue(withIdentifier: "goToComments", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToComments" {
            (segue.destination as! CommentsTableViewController).issue = selectedIssue!
            (segue.destination as! CommentsTableViewController).repository = repository
        }
    }

}
