//
//  IssueTableViewController.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 06.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import UIKit
import CoreData
import Swinject

class IssueTableViewController: UITableViewController {
    
    var repository: Repository!
    let variable = DIContainer.container.resolve(Variables.self)!
    let service = DIContainer.container.resolve(IssuesService.self)!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Issues> = {
        let request = NSFetchRequest<Issues>(entityName: "Issues")
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let departmentSort = NSSortDescriptor(key: "comments", ascending: false)
        request.sortDescriptors = [departmentSort]
        
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
        
        let title = repository.name
        self.title = title
        
        createRefreshController()
        getData()
    }
    
    func getData() {
        service.getIssues(repository: repository).catch { error in
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "issueCell", for: indexPath) as! IssueTableViewCell
        
        let issue = fetchedResultsController.object(at: indexPath)
        cell.initCell(issue: issue)

        return cell
    }
    
    var selectedIssue: Issues!
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedIssue = fetchedResultsController.object(at: indexPath)
        
        performSegue(withIdentifier: "goToComments", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? CommentsTableViewController)?.issue = selectedIssue
        (segue.destination as? CommentsTableViewController)?.repository = repository
    }

    @IBAction func addIssuePressed(_ sender: Any) {
        let alert = UIAlertController(title: "New issue", message: "Fill all fields", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Body"
        }
        
        let sendAction = UIAlertAction(title: "Send", style: .default) { (action) in
            if alert.textFields![0].text != "" && alert.textFields![1].text != "" {
                self.service.createIssue(title: alert.textFields![0].text!, body: alert.textFields![1].text!, repository: self.repository.name!).catch { error in
                        let alert = UIAlertController(title: "Problem", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Empty field", message: "Fill all fields, please", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            alert.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(sendAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension IssueTableViewController: NSFetchedResultsControllerDelegate {
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
