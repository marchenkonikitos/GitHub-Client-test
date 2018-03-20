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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = repository.name
        self.title = title
        
        loadIssueArray()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        let addButton = UIButton.init(type: .custom)
        addButton.setImage(UIImage(named: "add"), for: UIControlState.normal)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: addButton)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func loadIssueArray() {
        let jsonURLString = (repository.url)! + "/issues"
        let jsonURL = URL(string: jsonURLString)
        
        getData(url: jsonURL!)
        
        issuesArray = loadIssues()
    }
    
    func getData(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            guard err == nil else { return }
            
            do {
                let issuesData = try JSONDecoder().decode([IssueData].self, from: data)
                self.refreshControl?.endRefreshing()
                DispatchQueue.main.async {
                    self.saveIssues(issues: issuesData)
                    self.tableView.reloadData()
                }
            } catch {
                print("error")
            }
        }.resume()
    }
    
    func saveIssues(issues: [IssueData]) {
        clearIssues()
        
        for issue in issues {
            let title = issue.title
            let comments_url = issue.comments_url
            let comments = issue.comments
            let state = issue.state
            let url = issue.url
            
            guard saveIssue(comments_url: comments_url, title: title, comments: comments, state: state, url: url, repository: repository) else { return }
        }
        issuesFilter()
    }
    
    func issuesFilter() {
        issuesArray = loadIssues()
        
        issuesArray.filter{ $0.repository == repository }
        
        /*
        issuesArray.forEach { (issue) in
            if issue.url != (repository.url! + "/issues") {
                
                guard let index = issuesArray.index(of: issue) else {
                    return
                }
                
                issuesArray.remove(at: index)
            }
        }
         */
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
        let count = repository.open_issues_count
        return Int(UInt(count))
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
        }
    }

}
