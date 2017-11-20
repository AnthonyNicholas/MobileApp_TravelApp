//
//  LoginViewController.swift
//  OpenDayApp
//
//  Created by Anthony Nicholas on 17/11/17.
//  Copyright © 2017 Anthony Nicholas. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabaseUI
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
//    @IBOutlet weak var facebookLoginButton: UIButton!
    let userDAO : UserDAO = UserDAO()
    var facebookLoginButton: FBSDKLoginButton = FBSDKLoginButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        facebookButtonSetup()
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            if (user != nil && !GlobalManager.loginChecker) {
                GlobalManager.loginChecker = true
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        }        
    }
    
    func facebookButtonSetup(){
        facebookLoginButton = FBButton(view: view)
        facebookLoginButton.delegate = self
        view.addSubview(facebookLoginButton)
        
        //Setting up user permissions
        facebookLoginButton.readPermissions = ["email", "user_friends"]
        
        //Upon successfull log in
        if (FBSDKAccessToken.current()) != nil {
            print("here3");
        }
        else{
            print("No Facebook user is logged in!")
        }
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        DispatchQueue.global().async {
            self.userDAO.FacebookSignIn(result: result, error: error)
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        userDAO.FacebookSignOut()
        print("Facebook user successfully signed out!")
        GlobalManager.loginChecker = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
}
