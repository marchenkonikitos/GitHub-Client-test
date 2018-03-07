//
//  CommentsTableViewCell.swift
//  GitHub test
//
//  Created by Nikita Marchenko on 07.03.2018.
//  Copyright © 2018 Nikita Marchenko. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    @IBOutlet var commentName: UILabel!
    
    func initCell(comment: Comments) {
        commentName.text = comment.body
    }
}
