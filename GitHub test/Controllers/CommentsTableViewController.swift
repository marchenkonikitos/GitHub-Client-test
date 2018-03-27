//
//  CommentsTableViewController.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 07.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import UIKit

class CommentsTableViewController: UITableViewController {
    
    var issue = Issues()
    var repository = Repository()
    var commentsArray: [Comments] = []
    let variable = Variables()
    let commentService = CommentsServices()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = issue.title
        self.title = title
        
        getData()
    }
    
    func getData() {
        commentService.getComments(repository: repository, issue: issue, success: {
            self.commentsArray = self.commentService.loadIssues()
            self.tableView.reloadData()
        }) { error in
            let alert = UIAlertController(title: "Problem", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return commentsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentsTableViewCell
        
        if (commentsArray.count > 0) && (commentsArray.count > indexPath.row) {
            let commentForCell = commentsArray[indexPath.row]
            cell.initCell(comment: commentForCell)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
