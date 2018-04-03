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

//Save data
func saveData(context: NSManagedObjectContext) {
    do {
        try context.save()
    } catch {
        debugPrint(error.localizedDescription)
        print("Problem with save to CoreData")
    }
}

//MARK: -Repositories
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
func loadIssues() -> [Issues] {
    let context = getContext()
    var issues: [Issues] = []
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Issues")
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "comments", ascending: false)]
    
    do {
        issues = try context.fetch(fetchRequest) as! [Issues]
        return issues
    } catch {
        print("\nError loading issue array")
        return issues
    }
}

func clearIssues() -> Bool {
    let context = getContext()
    
    do {
        try context.fetch(Issues.fetchRequest()).forEach(context.delete)
        try context.save()
        return true
    } catch {
        debugPrint(error.localizedDescription)
        return false
    }
}

//MARK: -Comments
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
    
    do {
        try context.fetch(Comments.fetchRequest()).forEach(context.delete)
        try context.save()
        
        return true
    } catch {
        return false
    }
}

