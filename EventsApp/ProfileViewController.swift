//
//  ProfileViewController.swift
//  EventsApp
//
//  Created by Laura Nias on 14/02/2020.
//  Copyright © 2020 Laura Nias. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    
     @IBOutlet weak var myEventsList: UITableView!
    
    let cellId = "myEventId"
    var eventArray = [Event]()
    var userArray = [Users]()
    var eventTitle: String = ""
    var date: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callDelegates()
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        myEventsList.reloadData()
    }
    
    
    func fetchData(){
        retrieveData {
            (done) in
            if done {
                if eventArray.count > 0 {
                    myEventsList.isHidden = false
                }
                else {
                    myEventsList.isHidden = true
                }
            }
        }
        
        fetchUser()
            
    }
    
    func callDelegates(){
        myEventsList.delegate = self
        myEventsList.dataSource = self
        myEventsList.isHidden = true
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
    
    func fetchUser(){
        guard let manageContext = appDelegate?.persistentContainer.viewContext else {return}
            let request = NSFetchRequest<NSFetchRequestResult>(entityName:
            "Users")
            
            do {
                userArray = try manageContext.fetch(request) as! [Users]
                
                print("Event details retrieved successfully")
            }
            catch {
                print("Unable to retrieve data: ", error)
            }
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return eventArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for:indexPath) as! MyEventsTableViewCell
            
            let event = eventArray[indexPath.row]
            
            if(eventArray.count > 0){
                //if(event.userInterested){
                    cell.titleLabel.text = event.eventTitle
                        
                    let d = event.eventDate
                    let formDate = DateFormatter()
                    formDate.dateStyle = .short
                    formDate.locale = Locale(identifier: "en_UK")
                    if(d != nil){
                        date = formDate.string(from: d! as Date)
                        cell.dateLabel.text = date
                    }
              //  }
            }
            return cell
        }
    


}
