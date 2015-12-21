//
//  LoginViewController.swift
//  TimetablePlanner
//
//  Created by Cole Dunsby on 2015-12-13.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4

class LoginViewController: UIViewController {

    // MARK: - IBActions
    
    @IBAction func loginButtonTapped(sender: UIButton) {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile"]) { (user, error) -> Void in
            if user == nil {
                print("Uh oh. The user cancelled the Facebook login.")
            } else if user!.isNew {
                print("User signed up and logged in through Facebook!")
                
                let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id,first_name,last_name,email,birthday,gender"])
                request.startWithCompletionHandler({ (connection, result, error) -> Void in
                    if let fbUser = result as? NSDictionary {
                        let newUser = user as! TPUser
                        newUser.firstName = fbUser["first_name"] as? String
                        newUser.lastName = fbUser["last_name"] as? String
                        newUser.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        })
                    }
                })
            } else {
                print("User logged in through Facebook!")
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }

}
