//
//  CourseItemsViewController.swift
//  OpenDayApp
//
//  Created by Anthony Nicholas on 19/11/17.
//  Copyright © 2017 Anthony Nicholas. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import Firebase

class CourseItemsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    let courseDAO: CourseDAO = CourseDAO()
//    let userDAO: UserDAO = UserDAO()
    @IBOutlet weak var courseItemsTable: UITableView!
    
    //Array to store Course entities from the coredata
    var courseArray = [Course]()

    
    //viewDidLoad - set title and navigation buttons
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Courses"
        self.navigationItem.rightBarButtonItem = editButtonItem
        retrieveInformation()
    }
    
    //retrieve courseArray from Firebase DB and reload table data
    func retrieveInformation(){
        DispatchQueue.global().async{
            self.courseDAO.getAllCourses(completionHandler: { (courses) in
                self.courseArray = courses
                self.courseItemsTable.reloadData()
            })
        }
    }
    
    //Set number of rows in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseArray.count
    }
    
    
    //Set data in each cell based on firebase DB
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "courseCell", for: indexPath) as! CourseCell
        
        let courseAtThisIndex = courseArray[indexPath.row]
        cell.courseName.text = courseAtThisIndex.courseName
        self.courseDAO.getProfilePicture(course: courseAtThisIndex, completionHandler: { (image) in
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
        
        let selectedRow = courseItemsTable.indexPathForSelectedRow
        let cell = courseItemsTable.cellForRow(at: selectedRow!)! as! CourseCell
        self.performSegue(withIdentifier: "CourseExpertsSegue", sender: nil)
        
    }
    
    //Handle segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailView:CourseExpertsViewController = segue.destination as! CourseExpertsViewController
        let indexPath = courseItemsTable.indexPathForSelectedRow!
        let selectedCourse = courseArray[indexPath.row]
        detailView.course = selectedCourse
    }
    
    //    @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
    //    }
    
    //Reload table after coming back from detail view
    override func viewDidAppear(_ animated: Bool) {
        courseItemsTable.reloadData()
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
