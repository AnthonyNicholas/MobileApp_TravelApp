//
//  ProfileViewController.swift
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
import Firebase

class ProfileViewController: UIViewController {
    
    let userDAO: UserDAO = UserDAO()
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var hotCourse1Label: UILabel!
    @IBOutlet weak var hotCourse2Label: UILabel!
    @IBOutlet weak var hotCourse3Label: UILabel!
    var savedImage: UIImage?
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveInformation()

    }
    
    func retrieveInformation(){
        DispatchQueue.global().async{
            self.userDAO.getUserInformation { (user, snapshot) in
                self.user = user
                self.userName.text! = user.getFirstName() + " " + user.getLastName()
                self.userEmail.text! = user.getEmail()
                print(user.hotCoursesArray)

                if let course1 = user.hotCoursesArray[0]{
                    self.hotCourse1Label.text = course1
                }
                if let course2 = user.hotCoursesArray[1]{
                    self.hotCourse2Label.text = course2
                }
                if let course3 = user.hotCoursesArray[2]{
                    self.hotCourse3Label.text = course3
                }

                self.userDAO.getProfilePicture(user: user, completionHandler: { (image) in
                    DispatchQueue.main.async {
                        self.profilePicture.image = image
                    }
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
