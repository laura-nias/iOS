//
//  ViewController.swift
//  EventsApp
//
//  Created by Laura Nias on 06/02/2020.
//  Copyright © 2020 Laura Nias. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    var userArray = [Users]()
    
    var pass : String = ""
    var user : String = ""
    
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
                print("Info retrieved")
            }
            else {
                print("Error - no info")
            }
        }
    }
    
    @IBAction func login(_ sender: Any) {
       fetchData()
        guard let manageContext = appDelegate?.persistentContainer.viewContext else {return}
        if(email.text != "" && password.text != ""){
            if (user == email.text && pass == password.text){
                
             let userInfo = Users(context: manageContext)
                userInfo.loggedIn = true
                do {
                 try manageContext.save()
                    print("Saved")
                }
                catch {
                    print("Failed to save data: ", error.localizedDescription)
                
                }
                performSegue(withIdentifier: "login", sender: self)
            }
            else{
                let alert = UIAlertController(title: "Alert", message: "Username or password is incorrect", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else{
            let alert = UIAlertController(title: "Alert", message: "Username or password is empty", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func signUp(_ sender: UIButton) {
           performSegue(withIdentifier: "signUp", sender: self)
    }
       
   @IBAction func adminButton(_ sender: UIButton) {
        performSegue(withIdentifier: "admin", sender: self)
   }
    
    func retrieveData(completion: (_ complete: Bool) -> ()){
        guard let manageContext = appDelegate?.persistentContainer.viewContext else {return}
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        
        request.predicate = NSPredicate(format: "username = %@", email.text!)
        
         do {
            let fetchResult = try manageContext.fetch(request) as! [Users]
            if (fetchResult.count > 0)
            {
                let objectEntity : Users = fetchResult.first!
                if (objectEntity.username == email.text && objectEntity.password == password.text)
                {
                    user = objectEntity.username!
                    pass = objectEntity.password!
                    print("Info retrieved successfully")
                    completion(true)
                }
            }
            else{
                print("")
            }
         }
        catch {
            print("Unable to retrieve data: ", error)
            completion(false)
        }
    }
}
    
    
    


