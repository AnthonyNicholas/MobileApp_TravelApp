//
//  CourseExpertsViewController.swift
//  OpenDayApp
//
//  Created by Anthony Nicholas on 19/11/17.
//  Copyright © 2017 Anthony Nicholas. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CourseExpertsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    let userDAO: UserDAO = UserDAO()
    @IBOutlet weak var courseExpertsTable: UITableView!
    
    //Array to store Person entities from the firebase
    var userArray = [User]()
    weak var course: Course?

    
    //viewDidLoad - set title and navigation buttons
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Course Experts"
        retrieveInformation()
    }
    
    //retrieve userArray from Firebase DB and reload table data
    func retrieveInformation(){
        DispatchQueue.global().async{
            self.userDAO.getCourseExperts(course: (self.course?.courseName)!, completionHandler: { (users) in
                self.userArray = users
                self.courseExpertsTable.reloadData()
            })
        }
    }
    
    //Set number of rows in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    
    //Set data in each cell based on firebase DB
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseExpertCell", for: indexPath) as! CourseExpertCell
        
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
    
    //Segue to detail view when row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedRow = courseExpertsTable.indexPathForSelectedRow
        let cell = courseExpertsTable.cellForRow(at: selectedRow!)! as! CourseExpertCell
        self.performSegue(withIdentifier: "interviewSegue", sender: nil)
        
    }
    
    //Handle segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView:InterviewViewController = segue.destination as! InterviewViewController
        let indexPath = courseExpertsTable.indexPathForSelectedRow!
        let selectedPerson = userArray[indexPath.row]
        detailView.person = selectedPerson
    }

    //    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
    //    }
    
    //Reload table after coming back from detail view
    override func viewDidAppear(_ animated: Bool) {
        courseExpertsTable.reloadData()
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
