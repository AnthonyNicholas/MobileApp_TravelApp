//
//  User.swift
//  OpenDayApp
//
//  Created by Anthony Nicholas on 17/11/17.
//  Copyright © 2017 Anthony Nicholas. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON

class User{
    
    var firstName: String? = ""
    var lastName: String? = ""
    var email: String? = ""
    var profilePicture: String? = ""
    var video: String? = ""
    var userType: String? = ""
    var associatedCourse: String? = ""
    
    init(user: JSON){
        self.firstName! = user["firstName"].string!
        self.lastName! = user["lastName"].string!
        self.email! = user["email"].string!
        self.profilePicture! = user["profilePicture"].string!
        self.userType! = user["userType"].string!
        if let assocCourse = user["associatedCourse"].string{
            self.associatedCourse! = assocCourse
        }
        if let vid = user["video"].string{
            self.video! = vid
        }
    }

    func getFirstName() -> String{
        return self.firstName!
    }
    func setFirstName(firstName: String?){
        self.firstName! = firstName!
    }
    func getLastName() -> String{
        return self.lastName!
    }
    func setLastName(lastName: String?){
        self.lastName! = lastName!
    }
    func getEmail() -> String{
        return self.email!
    }
    func setEmail(email: String?){
        self.email! = email!
    }
    func getVideo() -> String{
        return self.video!
    }
    func setVidio(vidio: String?){
        self.video! = video!
    }
    func getUserType() -> String{
        return self.userType!
    }
    func setType(userType: String?){
        self.userType! = userType!
    }
    func getAssociatedCourse() -> String{
        return self.associatedCourse!
    }
    func setAssociatedCourse(associatedCourse: String?){
        self.associatedCourse! = associatedCourse!
    }
    
    
}
