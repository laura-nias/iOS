//
//  AdminController.swift
//  EventsApp
//
//  Created by Laura Nias on 06/03/2020.
//  Copyright © 2020 Laura Nias. All rights reserved.
//

import UIKit

class AdminController: UIViewController {

    @IBAction func adminLogin(_ sender: Any) {
        performSegue(withIdentifier: "adminLogin", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }
    


}
