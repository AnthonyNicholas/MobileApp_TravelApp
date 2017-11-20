//
//  Course.swift
//  OpenDayApp
//
//  Created by Anthony Nicholas on 19/11/17.
//  Copyright © 2017 Anthony Nicholas. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

class Course{
    
    var courseName: String? = ""
    var university: String? = ""
    var expertArray: [User] = []
    var courseDescription: String? = ""
    var profilePicture: String? = ""

    
    init(course: JSON){
        self.courseName! = course["Name"].string!
        self.university! = course["University"].string!
        self.courseDescription! = course["Description"].string!
        self.profilePicture! = course["profilePicture"].string!
    }
    
    func getCourseName() -> String{
        return self.courseName!
    }
    func setCourseName(courseName: String?){
        self.courseName! = courseName!
    }
    func getUniversity() -> String{
        return self.university!
    }
    func setUniversity(university: String?){
        self.university! = university!
    }
    func getCourseDescription() -> String{
        return self.courseDescription!
    }
    func setCourseDescription(courseDescription: String?){
        self.courseDescription! = courseDescription!
    }
    func getProfilePicture() -> String{
        return self.profilePicture!
    }
    func setProfilePicture(profilePicture: String?){
        self.profilePicture! = profilePicture!
    }

    
}
