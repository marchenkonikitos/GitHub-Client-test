//
//  ReposTableViewController.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 01.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import UIKit
import PromiseKit

class ReposTableViewController: UITableViewController {
    
    @IBOutlet var userImage: UIImageView!
    
    private var repositoriesArray: [Repository] = []
    private let variable = Variables()
    private let repositoriesService = RepositoryServices()
    private let userServices = UserServices()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        createRefreshController()
        getData()
        changeUserImage()
        changeNumberOfRepos()
    }
    
    //MARK: -Change datas in header
    func changeUserImage() {
        self.userImage.layer.masksToBounds = true
        self.userImage.layer.cornerRadius = self.userImage.frame.height / 2
        
        let imageData = userServices.getAvatar()
        self.userImage.image = UIImage(data: imageData as! Data)
    }
    
    func changeNumberOfRepos() {
        self.title = "Repositories: \(repositoriesArray.count)"
    }
    
    func createRefreshController() {
        let refreshController = UIRefreshControl()
        refreshController.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshController.tintColor = .gray
        refreshController.attributedTitle = NSAttributedString(string: "Refreshing")
        tableView.addSubview(refreshController)
    }
    
    @objc
    func refreshData(_ refresher: UIRefreshControl) {
        getData()
        changeNumberOfRepos()
        refresher.endRefreshing()
    }
    
    @objc
    func imageTapped(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            self.navigationController?.title = UserDefaults.standard.value(forKey: "userName") as? String
        } else if gesture.state == .ended {
            changeNumberOfRepos()
        }
    }
    
    //MARK: -Get and save repositories
    func getData() {
        repositoriesService.getRepositories().done {
            self.repositoriesArray = self.repositoriesService.loadRepos()
            self.tableView.reloadData()
            }.catch { error in
                let alert = UIAlertController(title: "Problem", message: error.localizedDescription, preferredStyle: .alert)
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
        
        (segue.destination as? IssueTableViewController)?.repository = selectedRepository!
    }
    
    @IBAction func imagePressed(_ sender: Any) {
        debugPrint("pressed")
    }
    
    
    @IBAction func logoutPressed(_ sender: Any) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let sb = UIStoryboard(name: "Main", bundle: nil)
        delegate.window?.rootViewController = sb.instantiateInitialViewController()
        
        
        userServices.logOut()
    }
}
