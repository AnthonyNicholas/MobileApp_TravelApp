//
//  CourseDAO.swift
//  OpenDayApp
//
//  Created by Anthony Nicholas on 19/11/17.
//  Copyright © 2017 Anthony Nicholas. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

class CourseDAO{
    
    // Gets course profile picture from firebase DB
    
    func getProfilePicture(course: Course?, completionHandler:@escaping(UIImage?)-> ()){
        let pictureString = course!.getProfilePicture()
        let PictureURL = URL(string: pictureString)!
        let session = URLSession(configuration: .default)
        
        let downloadPicTask = session.dataTask(with: PictureURL) { (data, response, error) in
            if let e = error {
                print("Error downloading picture: \(e)")
            } else {
                if (response as? HTTPURLResponse) != nil {
                    if data != nil {
                        let image = UIImage(data: data!)
                        completionHandler(image!)
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code")
                }
            }
        }
        downloadPicTask.resume()
    }
    
    // Retrieves all courses from firebase DB
    
    func getAllCourses(completionHandler:@escaping([Course]) ->()){
        print("getting courses")
        var retrievedCourses : [Course] = [Course]()
        Database.database().reference().child("Courses").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let newCourse: Course = Course(course: JSON(child.value!))
                print(newCourse.courseName)
                retrievedCourses.append(newCourse)
            }
            completionHandler(retrievedCourses)
        })
    }

    // Retrieves a specific course from firebase DB    
    func getSpecificCourse(courseName: String, completionHandler:@escaping([Course]) ->()){
        var retrievedCourse : [Course] = [Course]()
        Database.database().reference().child("Courses").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let newCourse: Course = Course(course: JSON(child.value!))
                if newCourse.getCourseName() == courseName{
                    retrievedCourse.append(newCourse)
                }
            }
            completionHandler(retrievedCourse)
        })
    }
    
    // Retrieves users of specified type, course from firebase DB
    
//    func getCourseExperts(course: String, completionHandler:@escaping([User]) ->()){
//
//        var retrievedUsers : [User] = [User]()
//        Database.database().reference().child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//            for child in snapshot.children.allObjects as! [DataSnapshot] {
//                let newUser: User = User(user: JSON(child.value!))
//                if newUser.getUserType() == "Expert" && newUser.getAssociatedCourse() == course{
//                    retrievedUsers.append(newUser)
//                }
//            }
//            completionHandler(retrievedUsers)
//        })
//    }
    
}


//    func getCourseInformation(completionHandler:@escaping(Course, DataSnapshot) ->()){
//        let currentCourseName = Auth.auth().currentCourse?.displayName
//        Database.database().reference().child("courses").child(currentCourseName!).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//            let course: Course = Course(course: JSON(snapshot.value!))
//            completionHandler(course, snapshot)
//        })
//    }
//
//    func saveProfileInformation(firstName: String?, lastName: String?){
//        let currentCourseName = Auth.auth().currentCourse?.displayName
//
//        Database.database().reference().child("courses").child(currentCourseName!).child("firstName").setValue(firstName!)
//        Database.database().reference().child("courses").child(currentCourseName!).child("lastName").setValue(lastName!)
//    }
//

//func createCourse(firstName: String?, lastName: String?, email: String?, profilePicture: String?, coursename: String?){
//    print("here for new course");
//    let databaseRef = Database.database().reference()
//    databaseRef.child("courses").child("\(coursename!)").setValue([
//        "firstName": firstName!,
//        "lastName": lastName!,
//        "email": email!,
//        "profilePicture": profilePicture!,
//        ])
//}



//    func checkForCourseExistance(fullName: String?, completionHandler:@escaping(Bool) ->()){
//        let databaseRef = Database.database().reference()
//
//        DispatchQueue.global().async {
//            databaseRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//                DispatchQueue.main.async {
//                    if(snapshot.hasChild("courses")){
//                        databaseRef.child("courses").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//                            if(snapshot.hasChild(fullName!)){
//                                completionHandler(true)
//                            }
//                            else{
//                                completionHandler(false)
//                            }
//                        })
//                    }
//                    else{
//                        completionHandler(false)
//                    }
//                }
//            })
//        }
//    }
