//
//  UserDAO.swift
//  UserDAO - User Data Access Object
//
//  Manages connection with Firebase database.
//
//  Created by Anthony Nicholas on 17/11/17.
//  Copyright © 2017 Anthony Nicholas. All rights reserved.
//

import Foundation
import Firebase
import SwiftyJSON
import FBSDKLoginKit
import FBSDKCoreKit

class UserDAO{
    
    func getUserInformation(completionHandler:@escaping(User, DataSnapshot) ->()){
        let currentUserName = Auth.auth().currentUser?.displayName
        print(currentUserName!)
        Database.database().reference().child("users").child(currentUserName!).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            print("Getting User Info")
            print(JSON(snapshot.value!))
            let user: User = User(user: JSON(snapshot.value!))
            completionHandler(user, snapshot)
        })
    }
    
    func saveProfileInformation(firstName: String?, lastName: String?){
        let currentUserName = Auth.auth().currentUser?.displayName
        
        Database.database().reference().child("users").child(currentUserName!).child("firstName").setValue(firstName!)
        Database.database().reference().child("users").child(currentUserName!).child("lastName").setValue(lastName!)
    }
    
    func createUser(firstName: String?, lastName: String?, email: String?, profilePicture: String?, userType: String?, username: String?){
        print("here for new user");
        let databaseRef = Database.database().reference()
        databaseRef.child("users").child("\(username!)").setValue([
            "firstName": firstName!,
            "lastName": lastName!,
            "email": email!,
            "profilePicture": profilePicture!,
            "userType": "Student",
            "video": "https://youtu.be/CUvZJ-DoeL0?t=59s"
            ])
    }
    
    func checkForUserExistance(fullName: String?, completionHandler:@escaping(Bool) ->()){
        let databaseRef = Database.database().reference()
        
        DispatchQueue.global().async {
            databaseRef.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                DispatchQueue.main.async {
                    if(snapshot.hasChild("users")){
                        databaseRef.child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                            if(snapshot.hasChild(fullName!)){
                                completionHandler(true)
                            }
                            else{
                                completionHandler(false)
                            }
                        })
                    }
                    else{
                        completionHandler(false)
                    }
                }
            })
        }
    }
    
    func FacebookSignIn(result: FBSDKLoginManagerLoginResult!, error: Error!){
        if let error = error {
            print(error.localizedDescription)
        }
        else{
            let deviceScale = Int(UIScreen.main.scale)
            let width = 100 * deviceScale
            let height = 100 * deviceScale
            
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, first_name, last_name, name, email, picture.width(\(width)).height(\(height))"]).start {
                (connection, result, err) in
                if(err != nil){
                    print("Failed graph request")
                }
                else{
                    let facebookData = JSON(result ?? {})
                    let fullName = facebookData["name"].string!
                    let firstName = facebookData["first_name"].string!
                    let lastName = facebookData["last_name"].string!
                    let email = facebookData["email"].string!
                    let picture = facebookData["picture"]["data"]["url"].string!
                    
                    self.checkForUserExistance(fullName: fullName, completionHandler: { (check) in
                        if(!check){
                            self.createUser(firstName: firstName, lastName: lastName, email: email, profilePicture: picture, userType: "Student", username: fullName)
                        }
                        else{
                            print("User has already been created!")
                        }
                    })
                }
            }
            guard let accessToken = FBSDKAccessToken.current() else {return}
            let loginCredentials = FacebookAuthProvider.credential(withAccessToken: (accessToken.tokenString)!)
            
            Auth.auth().signIn(with: loginCredentials, completion: { (user, error) in
                if(error != nil){
                    print("Firebase sign in with FB failed: ", error ?? "");
                    return
                }
                else{
                    print("FB user is successfully logged in to Firebase")
                }
            })
        }
    }
    
    func getProfilePicture(user: User?, completionHandler:@escaping(UIImage?)-> ()){
        let pictureString = user!.profilePicture
        let PictureURL = URL(string: pictureString!)!
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
    
    // Retrieves all users from firebase DB
    
    func getAllUsers(completionHandler:@escaping([User]) ->()){

        var retrievedUsers : [User] = [User]()
        Database.database().reference().child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let newUser: User = User(user: JSON(child.value!))
                retrievedUsers.append(newUser)
            }
            completionHandler(retrievedUsers)
        })
    }
    
    // Retrieves users of specified type, course from firebase DB
    
    func getCourseExperts(course: String, completionHandler:@escaping([User]) ->()){
        
        var retrievedUsers : [User] = [User]()
        Database.database().reference().child("users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let newUser: User = User(user: JSON(child.value!))
                if newUser.getUserType() == "Expert" && newUser.getAssociatedCourse() == course{
                    retrievedUsers.append(newUser)
                }
            }
            completionHandler(retrievedUsers)
        })
    }
    
    internal func FacebookSignOut(){
        try! Auth.auth().signOut()
    }
    
}
