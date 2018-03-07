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
    var commentsArray: [Comments] = []

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
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            guard err == nil else { return }
            
            do {
                let commentsData = try JSONDecoder().decode([CommentData].self, from: data)
                self.saveComments(comments: commentsData)
            } catch {
                print("error")
            }
        }.resume()
    }
    
    func saveComments(comments: [CommentData]) {
        clearComments()
        
        for comment in comments {
            let body = comment.body
            let html_url = comment.html_url
            
            guard saveComment(body: body, html_url: html_url, issue: issue) else { return }
        }
        
        commentsFilter()
    }
    
    func commentsFilter() {
        commentsArray = loadComments()
        
        for count in 0..<(commentsArray.count - 1) {
            if commentsArray[count] != issue {
                commentsArray.remove(at: count)
            }
        }
        
        print(commentsArray.count)
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
