//
//  ViewController.swift
//  TravelLocationApp
//
//  Created by Anthony Nicholas on 12/10/17.
//  Copyright © 2017 Anthony Nicholas. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var mainTable: UITableView!
    let placesRef = Database.database().reference().child("Places")

    // handler to the managege object context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Array to store Person entities from the coredata
    var fetchResults = [User]()
    
    //viewDidLoad - set title and navigation buttons
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Reviews"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUser))
        self.navigationItem.rightBarButtonItem = addButton
        self.navigationItem.leftBarButtonItem = editButtonItem
        placesRef.childByAutoId().setValue("Adelaide")
        
    }
    
    //Get number of items in coredata storage
    func fetchRecord() -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        var x   = 0
        fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [User])!
        x = fetchResults.count
        return x
    }

    //Set number of rows in tableView based on the coredata storage
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchRecord()
        
        
    }
    
    
    //Set data in each cell based on coredata storage
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! mainTableViewCell
        
        let userAtThisIndex = fetchResults[indexPath.row]
        
        cell.personTitle.text = userAtThisIndex.firstName! + " " + userAtThisIndex.lastName!
//        cell.personImage.image = UIImage(data: userAtThisIndex.image! as Data)
        cell.personTitle.delegate = self
        return cell
    }
    
    // Editing
    
    //Handle additions to table
    
    func addUser(){
        
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

    }
    
    //Set mainTable as editable table
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        mainTable.setEditing(editing, animated: animated)
    }

    // Handle user editing person title
    @IBAction func didEditUserTitle(_ sender: UITextField) {
        let selectedRow = mainTable.indexPathForSelectedRow
        let cell = mainTable.cellForRow(at: selectedRow!)! as! mainTableViewCell
        
        fetchResults[(selectedRow?.row)!].firstName = cell.personTitle.text
        do { try managedObjectContext.save()} catch {} // save the updated managed object context
        
        cell.personTitle.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    //Handle deletions from table using built in edit functionality
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        managedObjectContext.delete(fetchResults[indexPath.row])
//        fetchResults.remove(at:indexPath.row) // remove it from the fetch results array
//        do { try managedObjectContext.save()} catch {} // save the updated managed object context
//        mainTable.deleteRows(at: [indexPath], with: .fade)
    }

    //Segue to detail view when row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRow = mainTable.indexPathForSelectedRow
        let cell = mainTable.cellForRow(at: selectedRow!)! as! mainTableViewCell
        cell.personTitle.resignFirstResponder()
        self.performSegue(withIdentifier: "detail", sender: nil)
        
    }
    
    //Handle segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView:DetailViewController = segue.destination as! DetailViewController
        let indexPath = mainTable.indexPathForSelectedRow!
        let selectedPerson = fetchResults[indexPath.row]
        detailView.person = selectedPerson
            }
    
    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {        
    }
    
    //Reload table after coming back from detail view
    override func viewDidAppear(_ animated: Bool) {
        mainTable.reloadData()
    }

    //Finish editing when touches begin elsewhere    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

