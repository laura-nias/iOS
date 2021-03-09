//
//  SecondViewController.swift
//  EventsApp
//
//  Created by Laura Nias on 06/02/2020.
//  Copyright © 2020 Laura Nias. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBAction func confirm(_ sender: Any) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let info = Users(context: managedContext)
        
        info.firstName = firstName.text
        info.lastName = lastName.text
        info.username = email.text
        info.password = password.text
        
        do {
         try managedContext.save()
            print("User Details Saved")
            dismiss(animated: true, completion: nil)
            self.dismiss(animated: true)
        }
        catch {
            print("Failed to save data: ", error.localizedDescription)
        
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
