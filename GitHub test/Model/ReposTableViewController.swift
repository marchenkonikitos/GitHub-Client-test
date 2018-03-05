//
//  ReposTableViewController.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 01.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import UIKit
import Alamofire

class ReposTableViewController: UITableViewController {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var numberOfRepos: UILabel!
    
    var repositoriesArray = loadRepositories()
    var issuesArray = loadIssues()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        repositoriesArray = loadRepositories()
        if repositoriesArray?.count == 0 {
            let jsonURLString = UserDefaults.standard.value(forKey: "repos_url") as! String
            guard let jsonURL = URL(string: jsonURLString) else {
                return
            }
            getData(url: jsonURL)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeUserImage()
        changeNumberOfRepos()
    }
    
    func changeUserImage() {
        self.userImage.layer.masksToBounds = true
        self.userImage.layer.cornerRadius = self.userImage.frame.width / 2
        
        let imageURL = URL(string: UserDefaults.standard.value(forKey: "avatar_url") as! String)
        let imageData = NSData(contentsOf: imageURL!)
        
        self.userImage.image = UIImage(data: imageData! as Data)
        
        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(imageTapped))
        tapGesture.minimumPressDuration = 0.0
        userImage.isUserInteractionEnabled = true
        self.userImage.addGestureRecognizer(tapGesture)
        
    }
    
    func changeNumberOfRepos() {
        self.numberOfRepos.text = "Repositories: \(UserDefaults.standard.value(forKey: "numberOfRepos")!)"
    }
     
    func getData(url: URL) {
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            guard err == nil else { return }
            
            do {
                let reposData = try JSONDecoder().decode([ReposData].self, from: data)
                self.saveRepositories(repos: reposData)
                self.tableView.reloadData()
            } catch {
                print("error")
            }
        }.resume()
    }
    
    @objc
    func imageTapped(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            self.numberOfRepos.text = UserDefaults.standard.value(forKey: "userName") as? String
        } else if gesture.state == .ended {
            changeNumberOfRepos()
        }
    }
    
    func saveRepositories(repos: [ReposData]) {
        for repository in repos {
            let id = repository.id
            let name = repository.name
            let url = repository.url
            let has_issues = repository.has_issues
            let html_url = repository.html_url
            let open_issues_count = repository.open_issues_count
            
            guard let repos = saveRepository(id: id, name: name, url: url, html_url: html_url, has_issue: has_issues, open_issues_count: open_issues_count) else { return }
            
            if has_issues {
                let jsonURLString = url + "/issues"
                let jsonURL = URL(string: jsonURLString)!
                print(jsonURL)
                URLSession.shared.dataTask(with: jsonURL) { (data, response, err) in
                    guard let data = data else { return }
                    guard err == nil else { return }
                    print("ya tut")
                    do {
                        let issuesData = try JSONDecoder().decode([IssueData].self, from: data)
                        print("ya tut")
                        self.saveIssues(issues: issuesData, repository: repos)
                    } catch {
                        print("error")
                    }
                }
            }
        }
    }
    
    func saveIssues(issues: [IssueData], repository: Repository) {
        print("hi")
        for issue in issues {
            let comments_url = issue.comments_url
            let title = issue.title
            let comments = issue.comments
            let state = issue.state
            
            guard saveIssue(comments_url: comments_url, title: title, comments: comments, state: state, repository: repository) else { return }
            
        }
    }
    
    
    @IBAction func reloadButtonPressed(_ sender: Any) {
        guard clearRepositories() else { return }
        guard clearIssues() else { return }
        
        let jsonURLString = UserDefaults.standard.value(forKey: "repos_url") as! String
        guard let jsonURL = URL(string: jsonURLString) else {
            return
        }
        getData(url: jsonURL)
        
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let data = loadRepositories()
        return (data?.count)!
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reposCell", for: indexPath) as! RepositoryTableViewCell
        if repositoriesArray!.count > 0 {
            let repositoryForCell = repositoriesArray![indexPath.row]
            cell.initCell(repository: repositoryForCell)
        }
        
        return cell
    }
    
    var selectRepository: Repository?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectRepository = repositoriesArray?[indexPath.row]
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
