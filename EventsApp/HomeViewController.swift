//
//  HomeViewController.swift
//  EventsApp
//
//  Created by Laura Nias on 07/02/2020.
//  Copyright © 2020 Laura Nias. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {

    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let cellId = "eventId"
    var eventArray = [Event]()
    var eventTitle: String = ""
    var price: String = ""
    var date : String = ""
    var location : String = ""

    @IBOutlet weak var homeEvents: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callDelegates()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        
        homeEvents.reloadData()
    }
    
    func fetchData(){
        retrieveData {
            (done) in
            if done {
                if eventArray.count > 0 {
                    homeEvents.isHidden = false
                }
                else {
                    homeEvents.isHidden = true
                }
            }
        }
    }
    
    func callDelegates(){
        homeEvents.delegate = self
        homeEvents.dataSource = self
        homeEvents.isHidden = true
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for:indexPath) as! HomeEventsTableViewCell
        
        let event = eventArray[indexPath.row]
        
        if(eventArray.count > 0){
            cell.title.text = event.eventTitle
            
            let d = event.eventDate
            let formDate = DateFormatter()
            formDate.dateStyle = .short
            formDate.locale = Locale(identifier: "en_UK")
            if(d != nil){
                date = formDate.string(from: d! as Date)
                cell.date.text = date
            }
        }
        eventTitle = event.eventTitle!
        location = event.eventAddress!
        price = event.eventPrice!
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let details = segue.destination as! EventsPageViewController
        
        details.eventTitle = self.eventTitle
        details.price = self.price
        details.date = self.date
        details.location = self.location
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            var predicate: NSPredicate = NSPredicate()
            predicate = NSPredicate(format: "eventTitle contains[c] '\(searchText)'")
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedObjectContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Event")
            fetchRequest.predicate = predicate
            do {
                eventArray = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject] as! [Event]
            } catch let error as NSError {
                print("Could not fetch. \(error)")
            }
        }
    }

}
