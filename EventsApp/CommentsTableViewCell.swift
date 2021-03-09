//
//  CommentsTableViewCell.swift
//  EventsApp
//
//  Created by Laura Nias on 22/03/2020.
//  Copyright © 2020 Laura Nias. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userComments: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
