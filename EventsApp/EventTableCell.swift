//
//  EventTableCell.swift
//  EventsApp
//
//  Created by Laura Nias on 13/03/2020.
//  Copyright © 2020 Laura Nias. All rights reserved.
//

import UIKit

class EventTableCell: UITableViewCell {
    
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventAddress: UILabel!
    @IBOutlet weak var eventPrice: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
