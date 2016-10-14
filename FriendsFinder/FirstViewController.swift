//
//  FirstViewController.swift
//  FriendsFinder
//
//  Created by Nicolas Perez on 10/12/16.
//  Copyright © 2016 Nicolas Perez. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit


class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.loginBehavior = .systemAccount
        
        loginButton.center = self.view.center
        
        
        self.view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FirstViewController : FBSDKLoginButtonDelegate {

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if let e = error {
            let alert = UIAlertController(title: "Login Result", message: e.localizedDescription, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let nav = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewControler") as! UINavigationController
            
            self.navigationController?.present(nav, animated: true, completion: nil)
        }
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        
        if let _ = FBSDKAccessToken.current() {
            return false
        }
        else {
            return true
        }
    }

    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
}
