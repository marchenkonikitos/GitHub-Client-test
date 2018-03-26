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
func getContext() -> NSManagedObjectContext {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    return appDelegate.persistentContainer.viewContext
}

//MARK: -Repositories
//Save repositories
func saveRepository(context: NSManagedObjectContext) {
    
    do {
        try context.save()
    } catch {
        print("\nError save repository")
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
func saveIssue(commentsUrl: String, title: String, comments: Int32, state: String, url: String, number: Int32, repository: Repository) -> Bool{
    let context = getContext()
    let issue = NSEntityDescription.insertNewObject(forEntityName: "Issues", into: context) as! Issues
    
    issue.title = title
    issue.commentsUrl = commentsUrl
    issue.comments = comments
    issue.state = state
    issue.repository = repository
    issue.url = url
    issue.number = number
    
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
func saveComment(body: String, htmlUrl: String, issue: Issues) -> Bool {
    let context = getContext()
    let comment = NSEntityDescription.insertNewObject(forEntityName: "Comments", into: context) as! Comments
    
    comment.body = body
    comment.htmlUrl = htmlUrl
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

