//
//  EventsMapController.swift
//  EventsApp
//
//  Created by Laura Nias on 08/02/2020.
//  Copyright © 2020 Laura Nias. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class EventsMapController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var myMap: MKMapView!
    @IBOutlet weak var mapLabel: UILabel!
    var eventArray = [Event]()
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
    
        // Do any additional setup after loading the view.
        
        addLocation()

        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        //let userLocation = locations.last
        
        let center = CLLocationCoordinate2D(latitude: (self.locationManager.location!.coordinate.latitude), longitude: (self.locationManager.location!.coordinate.longitude))
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

        
        //let viewRegion = MKCoordinateRegion(center: (userLocation?.coordinate)!, latitudinalMeters: 600, longitudinalMeters: 600)
        
        geocode(latitude: locValue.latitude, longitude: locValue.longitude) { placemark, error in
        guard let placemark = placemark, error == nil else { return }
        
            DispatchQueue.main.async {
            let address1 = placemark.thoroughfare ?? "-"
            let city = placemark.locality ?? "-"
            let state = placemark.administrativeArea ?? "-"
            let pcode = placemark.postalCode ?? "-"
            let country = placemark.country ?? "-"
            self.mapLabel?.text = address1 + ", " + city + ", " + state + ", " + pcode + ", " + country
            }
        }
            
        self.myMap.showsUserLocation = true;
        self.myMap.setRegion(region, animated: true)
        
        locationManager.stopUpdatingLocation()
        
    }
    
    func addLocation(){
        guard let manageContext = appDelegate?.persistentContainer.viewContext else {return}
        let request = NSFetchRequest<NSFetchRequestResult>(entityName:
        "Event")
        
        do {
            eventArray = try manageContext.fetch(request) as! [Event]
            print("Event details retrieved successfully")
        }
        catch{
            print("Error getting event details")
        }
        
        for e in eventArray{
            let location = e.eventAddress
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(location!) { [weak self] placemarks, error in
                if let placemark = placemarks?.first, let location = placemark.location {
                
                    let mark = MKPlacemark(placemark: placemark)
                    
                    if var region = self?.myMap.region {
                        region.center = location.coordinate
                        region.span.longitudeDelta /= 8.0
                        region.span.latitudeDelta /= 8.0

                        self?.myMap.setRegion(region, animated: true)
                        self?.myMap.addAnnotation(mark)
                    
                    }
                }
            }
        }
        
}

        
    func geocode(latitude: Double, longitude: Double, completion: @escaping (CLPlacemark?, Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude))
        {
            completion($0?.first, $1)
            
        }
    }

}
