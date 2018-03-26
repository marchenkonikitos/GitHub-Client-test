//
//  CommentsTableViewController.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 07.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import UIKit
import Moya

class CommentsTableViewController: UITableViewController {
    
    var issue = Issues()
    var repository = Repository()
    var commentsArray: [Comments] = []
    let provider = MoyaProvider<CommentServices>()
    let variable = Variables()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = issue.title
        self.title = title
        
        loadCommentsArray()
    }
    
    func loadCommentsArray() {
        let jsonURLString = (issue.url)! + "/comments"
        let jsonURL = URL(string: jsonURLString)
        
        getData(url: jsonURL!)
        
        commentsArray = loadComments()
    }
    
    func getData(url: URL) {
        provider.request(.getComments(username: variable.login, repository: repository.name!, number: Int(issue.number))) { result in
            switch result {
            case let .success(moyaResponse):
                let data = moyaResponse.data
                
                do {
                    let commentsData = try JSONDecoder().decode([CommentData].self, from: data)
                    self.refreshControl?.endRefreshing()
                    DispatchQueue.main.async {
                        self.saveComments(comments: commentsData)
                        self.tableView.reloadData()
                    }
                } catch {
                    print("error")
                }
                
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func saveComments(comments: [CommentData]) {
        clearComments()
        
        for comment in comments {
            let body = comment.body
            let html_url = comment.htmlUrl
            
            guard saveComment(body: body, htmlUrl: html_url, issue: issue) else { return }
        }
        
        commentsFilter()
    }
    
    func commentsFilter() {
        commentsArray = loadComments()
        
        commentsArray.filter { $0.issues == issue }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let count = issue.comments
        return Int(count)
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
