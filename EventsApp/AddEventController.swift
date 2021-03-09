//
//  AddEventController.swift
//  EventsApp
//
//  Created by Laura Nias on 08/03/2020.
//  Copyright © 2020 Laura Nias. All rights reserved.
//

import UIKit
import CoreData
import Photos

class AddEventController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    var eventName = ""
    var eventDesc = ""
    var streetAdd = ""
    var cityAdd = ""
    var zip = ""
    var eventPrice = ""
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var street: UITextField!
    
    @IBOutlet weak var postcode: UITextField!
    
    @IBOutlet weak var city: UITextField!
    
    @IBOutlet weak var price: UITextField!
    
    @IBOutlet weak var imageSelected: UIImageView!
    
    @IBOutlet weak var date: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = eventName
        street.text = streetAdd
        city.text = cityAdd
        postcode.text = zip
        price.text = eventPrice
        date.date = Date()
        imageSelected.image = UIImage()
        
    }
    
    @IBAction func addImage(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected an image, provided the following: \(info)")
        }
        dismiss(animated: true, completion: nil)
        guard let manageContext = appDelegate?.persistentContainer.viewContext else {return}
        let event = Event(context: manageContext)
        
        event.eventImage = NSData(data: image.jpegData(compressionQuality: 0.3)!) as Data
        imageSelected.image = image
    }
    
    @IBAction func saveEvent(_ sender: Any) {
       guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
       let event = Event(context: managedContext)
        
        event.eventTitle = name.text
        event.eventAddress = street.text! + ", " + city.text! + ", " + postcode.text!
        event.eventPrice = price.text
        event.eventDate = date.date as NSDate
        
    
        if(event.eventTitle == ""){
            return
        }
        else {
           do {
            try managedContext.save()
               print("Event Details Saved")
               dismiss(animated: true, completion: nil)
               self.dismiss(animated: true)
           }
           catch {
               print("Failed to save data: ", error.localizedDescription)
           
           }
        }
    }

}
