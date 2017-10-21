//
//  DetailViewController.swift
//  TravelLocationApp
//
//  Created by Anthony Nicholas on 12/10/17.
//  Copyright © 2017 Anthony Nicholas. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, MKMapViewDelegate {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var PlaceImage: UIImageView!
    @IBOutlet weak var placeDescriptionLabel: UITextField!
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var mapType: UISegmentedControl!
    @IBOutlet weak var latTextField: UITextField!
    @IBOutlet weak var longTextField: UITextField!
    
    
    weak var place: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Do any additional setup after loading the view.
        placeNameLabel.text = place?.name
        placeDescriptionLabel.text = place?.desc
        PlaceImage.image = UIImage(data: place?.image! as! Data)
        placeDescriptionLabel.delegate = self
        showMap(sender: mapType)
    }
    
    //Handle image selection by user
    
    @IBAction func didPressSelectImage(_ sender: Any) {
        let photoPicker = UIImagePickerController ()
        photoPicker.delegate = self
        photoPicker.sourceType = .photoLibrary
        self.present(photoPicker, animated: true, completion: nil)
    }

    //Use image picker & save selected image to core data
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        picker .dismiss(animated: true, completion: nil)
        let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        PlaceImage.image = newImage
        let imageData = UIImagePNGRepresentation(newImage!)
        place?.image = imageData! as NSData
        do { try self.managedObjectContext.save() } catch _ {}

    }

    //Allow user to edit description of place
    
    @IBAction func didEditDescription(_ sender: UITextField) {
        place?.desc = placeDescriptionLabel.text
        do { try self.managedObjectContext.save() } catch _ {}
        placeDescriptionLabel.resignFirstResponder()
    }
    
    //Finish editing when touches begin elsewhere
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        placeDescriptionLabel.resignFirstResponder()
        view.endEditing(true)
    }
    
    //Finish editing when press return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                placeDescriptionLabel.resignFirstResponder()
                self.view.endEditing(true)
        return true
    }

    @IBAction func showMap(_ sender: Any) {
        
        switch(mapType.selectedSegmentIndex)
        {
        case 0:
            map.mapType = MKMapType.standard
        case 1:
            map.mapType = MKMapType.satellite
        case 2:
            map.mapType = MKMapType.hybrid
        default:
            map.mapType = MKMapType.standard
        }
        
        let geoCoder = CLGeocoder();
        let addressString = place?.name
        CLGeocoder().geocodeAddressString(addressString!, completionHandler:
            {(placemarks, error) in
                
                if error != nil {
                    print("Geocode failed: \(error!.localizedDescription)")
                } else if placemarks!.count > 0 {
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
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = coordinates
//        annotation.title = "Phoenix"
//        annotation.subtitle = "AZ"
//
//        self.map.addAnnotation(annotation)
        
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
}
