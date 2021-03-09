//
//  EventsPageViewController.swift
//  EventsApp
//
//  Created by Laura Nias on 22/03/2020.
//  Copyright © 2020 Laura Nias. All rights reserved.
//

import UIKit
import CoreData

class EventsPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellId = "commentId"
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var commentArray = [UserComments]()
    var eventArray = [Event]()
    
    var eventTitle: String = ""
    var price: String = ""
    var date: String = ""
    var location : String = ""
    
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var interestedToggle: UISwitch!
    @IBOutlet weak var commentBox: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callDelegates()
        
        titleLabel.text = eventTitle
        locLabel.text = location
        dateLabel.text = date
        priceLabel.text = price
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
           fetchData()
           commentsTableView.reloadData()
    }
    
    func fetchData(){
        retrieveData {
            (done) in
            if done {
                if commentArray.count > 0 {
                    commentsTableView.isHidden = false
                    commentArray.reverse()
                }
                else {
                    commentsTableView.isHidden = true
                }
            }
        }
    }
    
    func callDelegates(){
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        commentsTableView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for:indexPath) as! CommentsTableViewCell
        
        let comment = commentArray[indexPath.row]
    
        cell.userName.text = "Name"
        cell.userComments.text = comment.comment
    
        return cell
    }
    
    @IBAction func addComment(_ sender: Any) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let comments = UserComments(context: managedContext)
        
        comments.comment = commentBox.text
        
        
        do {
         try managedContext.save()
            print("Comment Saved")
            commentBox.text = ""
            fetchData()
            commentsTableView.reloadData()
        }
        catch {
            print("Failed to save data: ", error.localizedDescription)
        
        }
        
    }
    
    func retrieveData(completion: (_ complete: Bool) -> ()){
        guard let manageContext = appDelegate?.persistentContainer.viewContext else {return}
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:
        "UserComments")
        
        do {
            commentArray = try manageContext.fetch(request) as! [UserComments]
            print("Event details retrieved successfully")
            completion(true)
        }
        catch{
            print("Unable to retrieve data: ", error)
            completion(false)
        }
    }
    @IBAction func interested(_ sender: Any) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:
        "Event")
        let event = Event(context: managedContext)
        
        let interested = interestedToggle.isOn
        
        event.userInterested = interested
        
        do {
            eventArray = try managedContext.fetch(request) as! [Event]
            print("Event details retrieved successfully")
        }
        catch{
            print("Unable to retrieve data: ", error)
        }
    }
    
   
    
}
