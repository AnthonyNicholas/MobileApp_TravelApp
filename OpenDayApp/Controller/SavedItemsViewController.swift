//
//  SavedItemsViewController.swift
//  OpenDayApp
//
//  Created by Anthony Nicholas on 18/11/17.
//  Copyright © 2017 Anthony Nicholas. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SavedItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    let userDAO: UserDAO = UserDAO()
    @IBOutlet weak var savedItemsTable: UITableView!

    //Array to store Person entities from the coredata
    var userArray = [User]()
    
    //viewDidLoad - set title and navigation buttons
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Saved Items"
        self.navigationItem.rightBarButtonItem = editButtonItem
        retrieveInformation()
    }
    
    //retrieve userArray from Firebase DB and reload table data
    func retrieveInformation(){
        DispatchQueue.global().async{
            self.userDAO.getAllUsers(completionHandler: { (users) in
                self.userArray = users
                self.savedItemsTable.reloadData()
            })
        }
    }
    
    //Set number of rows in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    
    //Set data in each cell based on firebase DB
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SavedItemCell
        
        let userAtThisIndex = userArray[indexPath.row]
        
        cell.userName.text = userAtThisIndex.firstName! + " " + userAtThisIndex.lastName!
        self.userDAO.getProfilePicture(user: userAtThisIndex, completionHandler: { (image) in
            DispatchQueue.main.async {
                if let thumbnailImage = image{
                    cell.profilePicture.image = thumbnailImage
                    cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.size.width / 8;
                }
                else{
                    cell.profilePicture.image = #imageLiteral(resourceName: "stickGirl")
                }
                
            }
        })
        return cell
    }
    
    // Editing
    
    //Handle additions to table
    
//    func addUser(){
    
        //        let ent = NSEntityDescription.entity(forEntityName: "User", in: self.managedObjectContext)
        //        let newUser = User(entity: ent!, insertInto: self.managedObjectContext)
        //        newUser.firstName = "Anthony"
        //        newUser.lastName = "Nicholas"
        //        newUser.email = "antfellow@gmail.com"
        //        let imageData = UIImagePNGRepresentation(#imageLiteral(resourceName: "AN"))
        //        newUser.image = imageData! as NSData
        //
        //        // save the updated context
        //        do { try self.managedObjectContext.save() } catch _ {}
        //
        //        // reload the table with added row
        //        mainTable.reloadData()
        
//    }
    
    //Set mainTable as editable table
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//        savedItemsTable.setEditing(editing, animated: animated)
//    }
    
    // Handle user editing person title
//    @IBAction func didEditUserTitle(_ sender: UITextField) {
//        let selectedRow = mainTable.indexPathForSelectedRow
//        let cell = mainTable.cellForRow(at: selectedRow!)! as! mainTableViewCell
//
//        fetchResults[(selectedRow?.row)!].firstName = cell.personTitle.text
//        do { try managedObjectContext.save()} catch {} // save the updated managed object context
//
//        cell.personTitle.resignFirstResponder()
//        self.view.endEditing(true)
//    }
    
    //Handle deletions from table using built in edit functionality
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        //        managedObjectContext.delete(fetchResults[indexPath.row])
//        //        fetchResults.remove(at:indexPath.row) // remove it from the fetch results array
//        //        do { try managedObjectContext.save()} catch {} // save the updated managed object context
//        //        mainTable.deleteRows(at: [indexPath], with: .fade)
//    }
    
    //Segue to detail view when row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRow = savedItemsTable.indexPathForSelectedRow
        let cell = savedItemsTable.cellForRow(at: selectedRow!)! as! SavedItemCell
        self.performSegue(withIdentifier: "interview", sender: nil)
        
    }
    
    //Handle segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView:InterviewViewController = segue.destination as! InterviewViewController
        let indexPath = savedItemsTable.indexPathForSelectedRow!
        let selectedPerson = userArray[indexPath.row]
        detailView.person = selectedPerson
    }
    
//    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
//    }
    
    //Reload table after coming back from detail view
    override func viewDidAppear(_ animated: Bool) {
        savedItemsTable.reloadData()
    }
    
//    //Finish editing when touches begin elsewhere
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
