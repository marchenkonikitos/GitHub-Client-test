//
//  CommentsTableViewController.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 07.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import UIKit
import CoreData
import Swinject

class CommentsTableViewController: UITableViewController {
    
    var issue: Issues!
    var repository: Repository!
    let variable = DIContainer.container.resolve(Variables.self)!
    let service = DIContainer.container.resolve(CommentsServices.self)!
    let issuesService = DIContainer.container.resolve(IssuesService.self)!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Comments> = {
        let request = NSFetchRequest<Comments>(entityName: "Comments")
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            debugPrint(error.localizedDescription)
        }
        return frc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = issue.title
        self.title = title
        
        createRefreshController()
        getData()
    }
    
    func getData() {
        service.getComments(repository: repository.name!, issue: issue).catch { error in
                let alert = UIAlertController(title: "Problem", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
        }
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
        refresher.endRefreshing()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let count = fetchedResultsController.sections?[section].numberOfObjects {
            return count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentsTableViewCell
        
        let comment = fetchedResultsController.object(at: indexPath)
        cell.initCell(comment: comment)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    @IBAction func closePressed(_ sender: Any) {
        issuesService.closeIssue(repository: repository.name!, number: Int(issue.number)).done {
            self.navigationController?.popViewController(animated: true)
            }.catch { error in
                let alert = UIAlertController(title: "Problem", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
        }
    }
}

extension CommentsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.moveRow(at: indexPath, to: newIndexPath)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}

