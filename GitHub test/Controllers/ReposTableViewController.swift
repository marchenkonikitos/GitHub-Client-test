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
    
    var repositoriesArray: [Repository] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    
        getData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
        
        changeUserImage()
        changeNumberOfRepos()
    }
    
    //MARK: -Change datas in header
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
    
    @objc
    func imageTapped(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            self.numberOfRepos.text = UserDefaults.standard.value(forKey: "userName") as? String
        } else if gesture.state == .ended {
            changeNumberOfRepos()
        }
    }
    
    //MARK: -Get and save repositories and issues data
    func getData() {
        let jsonURLString = UserDefaults.standard.value(forKey: "repos_url") as! String
        guard let jsonURL = URL(string: jsonURLString) else { return }
        
        URLSession.shared.dataTask(with: jsonURL) { (data, response, err) in
            let stringFromData = String(data: data!, encoding: .utf8)
            //print(stringFromData)
            guard let data = data else { return }
            guard err == nil else { return }
            
            do {
                let reposData = try JSONDecoder().decode([ReposData].self, from: data)
                self.refreshControl?.endRefreshing()
                DispatchQueue.main.async {
                    self.saveRepositories(repos: reposData)
                    self.tableView.reloadData()
                }
            } catch {
                print("error")
            }
        }.resume()
    }
    
    func saveRepositories(repos: [ReposData]) {
        clearRepositories()
        
        for repository in repos {
            let id = repository.id
            let name = repository.name
            let url = repository.url
            let hasIssues = repository.hasIssues
            let htmlUrl = repository.htmlUrl
            let openIssuesCount = repository.openIssuesCount
            
            guard saveRepository(id: id, name: name, url: url, htmlUrl: htmlUrl, hasIssues: hasIssues, openIssuesCount: openIssuesCount) != nil else { return }
        }
        
        repositoriesArray = loadRepositories()
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let data = loadRepositories()
        return (data.count)
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reposCell", for: indexPath) as! RepositoryTableViewCell
        
        if repositoriesArray.count > 0 {
            let repositoryForCell = repositoriesArray[indexPath.row]
            cell.initCell(repository: repositoryForCell)
        }
        
        return cell
    }
    
    var selectedRepository: Repository?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        repositoriesArray = loadRepositories()
        selectedRepository = repositoriesArray[indexPath.row]
        
        performSegue(withIdentifier: "goToIssues", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToIssues" {
            (segue.destination as! IssueTableViewController).repository = selectedRepository!
        }
    }
}
