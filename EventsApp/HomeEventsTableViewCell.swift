//
//  HomeEventsTableViewCell.swift
//  EventsApp
//
//  Created by Laura Nias on 22/03/2020.
//  Copyright © 2020 Laura Nias. All rights reserved.
//

import UIKit

class HomeEventsTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
