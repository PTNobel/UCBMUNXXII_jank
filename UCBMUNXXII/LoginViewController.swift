//
//  LoginViewController.swift
//  UCBMUNXXII
//
//  Created by Nikhil Gahlot on 2/16/18.
//  Copyright © 2018 UCBMUN. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController {
    

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
//        if (Auth.auth().currentUser != nil){
//            self.performSegue(withIdentifier: "loggedIn", sender: nil)
//        }
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
                print("already logged in")
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "postFeed") as! PostFeedViewController
//                self.present(vc, animated: false, completion: nil)
////                self.tabBarController?.pushViewController(vc, animated: true)
////                self.tabBarController?.performSegue(withIdentifier: "showFeed", sender: nil)
                self.performSegue(withIdentifier: "loggedIn", sender: nil)
            }
        }
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func tryLogin(sender: AnyObject) {
        let email = emailField.text
        let password = passwordField.text
    if email != "" && password != "" {
       Auth.auth().signIn(withEmail: emailField.text!,
                               password: passwordField.text!)
    }
    else{
        signupErrorAlert(title: "Oops!", message: "Don't forget to enter your email, password, and a username.")
        }
    }
    
    func signupErrorAlert(title: String, message: String) {
        
        // Called upon signup error to let the user know signup didn't work.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
