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
    
    weak var place: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Do any additional setup after loading the view.
        placeNameLabel.text = place?.name
        placeDescriptionLabel.text = place?.desc
        PlaceImage.image = UIImage(data: place?.image! as! Data)
        placeDescriptionLabel.delegate = self
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

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
}
