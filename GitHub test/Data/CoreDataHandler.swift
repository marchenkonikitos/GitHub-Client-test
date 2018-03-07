//
//  CoreDataHandler.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 30.11.2017.
//  Copyright © 2017 Nikita Marchenko. All rights reserved.
//

import UIKit
import CoreData

//Get context
private func getContext() -> NSManagedObjectContext {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    return appDelegate.persistentContainer.viewContext
}

//MARK: -Repositories
//Save repositories
func saveRepository(id: Int32,name: String, url: String, html_url: String, has_issue: Bool, open_issues_count: Int32) -> Repository? {
    let context = getContext()
    let repos = NSEntityDescription.insertNewObject(forEntityName: "Repository", into: context) as! Repository
    
    repos.id = id
    repos.name = name
    repos.has_issues = has_issue
    repos.html_url = html_url
    repos.url = url
    repos.open_issues_count = open_issues_count

    do {
        try context.save()
        return repos
    } catch {
        print("\nError repository car")
        return nil
    }
}

func loadRepositories() -> [Repository] {
    let context = getContext()
    var repositories: [Repository] = []

    do {
        repositories = try context.fetch(Repository.fetchRequest())
        return repositories
    } catch {
        print("\nError loading repositories array")
        return repositories
    }
}

func clearRepositories() -> Bool {
    let context = getContext()
    let delete = NSBatchDeleteRequest(fetchRequest: Repository.fetchRequest())

    do {
        try context.execute(delete)
        return true
    } catch {
        return false
    }
}

//MARK: -Issues
func saveIssue(comments_url: String, title: String, comments: Int32, state: String, url: String, repository: Repository) -> Bool{
    let context = getContext()
    let issue = NSEntityDescription.insertNewObject(forEntityName: "Issues", into: context) as! Issues
    
    issue.title = title
    issue.comments_url = comments_url
    issue.comments = comments
    issue.state = state
    issue.repository = repository
    
    do {
        try context.save()
        return true
    } catch {
        print("\nError save issue")
        return false
    }
}

func loadIssues() -> [Issues] {
    let context = getContext()
    var issues: [Issues] = []
    
    do {
        issues = try context.fetch(Issues.fetchRequest())
        return issues
    } catch {
        print("\nError loading issue array")
        return issues
    }
}

func clearIssues() -> Bool {
    let context = getContext()
    let delete = NSBatchDeleteRequest(fetchRequest: Issues.fetchRequest())
    
    do {
        try context.execute(delete)
        return true
    } catch {
        return false
    }
}

//MARK: -Issues
func saveComment(body: String, html_url: String, issue: Issues) -> Bool {
    let context = getContext()
    let comment = NSEntityDescription.insertNewObject(forEntityName: "Comments", into: context) as! Comments
    
    comment.body = body
    comment.html_url = html_url
    comment.issues = issue
    
    do {
        try context.save()
        return true
    } catch {
        print("\nError save comment")
        return false
    }
}

func loadComments() -> [Comments] {
    let context = getContext()
    var comments: [Comments] = []
    
    do {
        comments = try context.fetch(Comments.fetchRequest())
        return comments
    } catch {
        print("\nError loading comments array")
        return comments
    }
}

func clearComments() -> Bool {
    let context = getContext()
    let delete = NSBatchDeleteRequest(fetchRequest: Comments.fetchRequest())
    
    do {
        try context.execute(delete)
        return true
    } catch {
        return false
    }
}

