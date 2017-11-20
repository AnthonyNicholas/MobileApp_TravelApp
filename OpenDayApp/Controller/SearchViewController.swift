//
//  SearchViewController.swift
//  OpenDayApp
//
//  Created by Anthony Nicholas on 18/11/17.
//  Copyright © 2017 Anthony Nicholas. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabaseUI
import FBSDKLoginKit
import FBSDKCoreKit
import MapKit

class SearchViewController: UIViewController, MKMapViewDelegate {
    
    let userDAO: UserDAO = UserDAO()
    @IBOutlet weak var bottomToolbar: UIToolbar!    
    @IBOutlet weak var logoutButton: UIToolbar!
//    @IBOutlet weak var mapType: UISegmentedControl!

    @IBOutlet weak var searchMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPins()
     
    }

    @IBAction func logOut(_ sender: UIBarButtonItem) {
        userDAO.FacebookSignOut()
    }
    
    func addPins(){
        // add an annotation
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = coordinates
//        annotation.title = "Phoenix"
//        annotation.subtitle = "AZ"
//        self.searchMap.addAnnotation(annotation)
        
            let geoCoder = CLGeocoder();
            let addressString = person?.name
            CLGeocoder().geocodeAddressString(addressString!, completionHandler:
                {(personmarks, error) in
    
                    if error != nil {
                        print("Geocode failed: \(error!.localizedDescription)")
                    } else if personmarks!.count > 0 {
                        let placemark = placemarks![0]
                        let location = placemark.location
                        let coords = location!.coordinate
                        self.latTextField.text = String(coords.latitude)
                        self.longTextField.text = String(coords.longitude)
    
                        let span = MKCoordinateSpanMake(0.05, 0.05)
                        let region = MKCoordinateRegion(center: placemark.location!.coordinate, span: span)
                        self.map.setRegion(region, animated: true)
                        let ani = MKPointAnnotation()
                        ani.coordinate = placemark.location!.coordinate
                        ani.title = placemark.locality
                        ani.subtitle = placemark.subLocality
                        self.map.addAnnotation(ani)
                    }
            })
        
        // add an annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = "Phoenix"
        annotation.subtitle = "AZ"

        self.map.addAnnotation(annotation)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
