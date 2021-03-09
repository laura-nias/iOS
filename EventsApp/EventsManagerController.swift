//
//  EventsManagerController.swift
//  EventsApp
//
//  Created by Laura Nias on 08/03/2020.
//  Copyright © 2020 Laura Nias. All rights reserved.
//

import UIKit
import CoreData


class EventsManagerController: UIViewController {
    
    let cellId = "CellId"
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    @IBOutlet weak var manageEventTable: UITableView!
    
    var eventArray = [Event]()
    var eventName: String = ""
    var price: String = ""
    var street: String = ""
    var city: String = ""
    var zip: String = ""
    var date = Date()
    var eventImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callDelegates()
        //manageEventTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        
        manageEventTable.reloadData()
    }
    
    func fetchData(){
        retrieveData {
            (done) in
            if done {
                if eventArray.count > 0 {
                    manageEventTable.isHidden = false
                }
                else {
                    manageEventTable.isHidden = true
                }
            }
        }
    }
    
    func callDelegates(){
        manageEventTable.delegate = self
        manageEventTable.dataSource = self
        manageEventTable.isHidden = true
    }
    
}

extension EventsManagerController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for:indexPath) as! EventTableCell
        let event = eventArray[indexPath.row]
        
        if(eventArray.count > 0){
            let test = event.eventImage
            if(test != nil){
                cell.eventImage.image = UIImage(data: test!)
            }
            cell.eventTitle.text = event.eventTitle
            cell.eventAddress.text = event.eventAddress
            cell.eventPrice.text = event.eventPrice
            
            let d = event.eventDate
            let formDate = DateFormatter()
            formDate.dateStyle = .short
            if(d != nil){
                cell.eventDate.text = formDate.string(from: d! as Date)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    internal func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit"){
            (action, indexPath) in self.editData(indexPath: indexPath)
            self.fetchData()
            tableView.setEditing(true, animated: true)
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete"){
            (action, indexPath) in self.deleteData(indexPath: indexPath)
            self.fetchData()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        return [deleteAction, editAction]
    }
}

extension EventsManagerController {
    
    func retrieveData(completion: (_ complete: Bool) -> ()){
        guard let manageContext = appDelegate?.persistentContainer.viewContext else {return}
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:
        "Event")
        
        do {
            eventArray = try manageContext.fetch(request) as! [Event]
            print("Event details retrieved successfully")
            completion(true)
        }
        catch{
            print("Unable to retrieve data: ", error)
            completion(false)
        }
    }
    
    func deleteData(indexPath: IndexPath){
        guard let manageContext = appDelegate?.persistentContainer.viewContext else {return}
        manageContext.delete(eventArray[indexPath.row])
        
        do {
            try manageContext.save()
            print("Deleted")
        }
        catch{
            print("Failed to delete data: ", error.localizedDescription)
        }
    }
    
    func editData(indexPath: IndexPath){
        let delimiter = ", "
        let newstr = eventArray[indexPath.row].eventAddress!
        print(newstr)
        let address = newstr.components(separatedBy: delimiter)
        self.eventName = eventArray[indexPath.row].eventTitle ?? ""
        self.street = address[0]
        self.city = address[1]
        self.zip = address[2]
        self.price = eventArray[indexPath.row].eventPrice ?? ""
        
        //self.date = (eventArray[indexPath.row].eventDate as Date?)!
        
        self.performSegue(withIdentifier: "newEvent", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let details = segue.destination as! AddEventController
        
        details.eventName = self.eventName
        details.streetAdd = self.street
        details.cityAdd = self.city
        details.zip = self.zip
        details.eventPrice = self.price
        //details.date.date = self.date
        //details.imageSelected.image = self.eventImage
    }
}
