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
    var savedImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveInformation()

    }
    
    func retrieveInformation(){
        DispatchQueue.global().async{
            self.userDAO.getUserInformation { (user, snapshot) in
                self.userDAO.getProfilePicture(user: user, completionHandler: { (image) in
                    DispatchQueue.main.async {
                        self.userName.text! = user.getFirstName() + " " + user.getLastName()
                        self.userEmail.text! = user.getEmail()
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
