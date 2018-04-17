//
//  RepositoryTableViewCell.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 03.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    
    @IBOutlet var repositoryName: UILabel!
    @IBOutlet var issuesCount: UILabel!
    
    func initCell(repository: Repository) {
        repositoryName.text = repository.name
        issuesCount.text = String(repository.openIssuesCount) + " issues"
    }
}
