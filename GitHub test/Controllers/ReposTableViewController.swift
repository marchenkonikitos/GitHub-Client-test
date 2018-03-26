//
//  ReposTableViewController.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 01.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var numberOfRepos: UILabel!
    
    private var repositoriesArray: [Repository] = []
    private let variable = Variables()
    private let repositoriesService = RepositoryServices()
    private let userServices = UserServices()
    

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
        
        let imageData = userServices.getAvatar()
        
        self.userImage.image = UIImage(data: imageData as Data)
        
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
        repositoriesService.getRepositories(success: {
            self.repositoriesArray = self.repositoriesService.loadRepos()
            self.tableView.reloadData()
        }, failed: { error in
            let alert = UIAlertController(title: "Problem", message: error, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        })
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return repositoriesArray.count
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
