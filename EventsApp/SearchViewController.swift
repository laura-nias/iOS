//
//  SearchViewController.swift
//  EventsApp
//
//  Created by Laura Nias on 23/03/2020.
//  Copyright © 2020 Laura Nias. All rights reserved.
//

import UIKit
import CoreData

class SearchViewController: UIViewController {

    let cellId = "cellId"
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var eventArray = [Event]()
    
    @IBOutlet weak var search: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
           fetchData()
       }
    
    func fetchData(){
        retrieveData {
            (done) in
            if done {
                if eventArray.count > 0 {
                    search.isHidden = false
                }
                else {
                    search.isHidden = true
                }
            }
        }
    }
    
    func retrieveData(completion: (_ complete: Bool) -> ()){
        guard let manageContext = appDelegate?.persistentContainer.viewContext else {return}
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:
        "Event")
        
        do {
            eventArray = try manageContext.fetch(request) as! [Event]
            print("Event details retrieved successfully")
            completion(true)
        }
        catch {
            print("Unable to retrieve data: ", error)
            completion(false)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
