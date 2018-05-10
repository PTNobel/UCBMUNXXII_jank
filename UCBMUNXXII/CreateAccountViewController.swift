//
//  CreateAccountViewController.swift
//  UCBMUNXXII
//
//  Created by Nikhil Gahlot on 2/16/18.
//  Copyright © 2018 UCBMUN. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CreateAccountViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        var username = usernameField.text
        let email = emailField.text
        let password = passwordField.text
        
        if username != "" && email != "" && password != "" {
            username = username! + "@ucbmun.xxii"
            
            // Set Email and Password for the New User.
            Auth.auth().createUser(withEmail: username!,
                                       password: password!) { user, error in
                                        if error == nil {
                                            // 3
                                            Auth.auth().signIn(withEmail: username!,
                                                                   password: password!)
                                            self.dismiss(animated: true, completion: {})
                                        } else{
                                            self.signupErrorAlert(title: "Oops!", message: "Having some trouble creating your account. Try again.")
                                        }
            }
//            DataService.dataService.BASE_REF.createUser(email, password: password, withValueCompletionBlock: { error, result in
//
//                if error != nil {
//
//                    // There was a problem.
//                    self.signupErrorAlert("Oops!", message: "Having some trouble creating your account. Try again.")
//
//                } else {
//
//                    // Create and Login the New User with authUser
//                    DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: {
//                        err, authData in
//
//                        let user = ["provider": authData.provider!, "email": email!, "username": username!]
//
//                        // Seal the deal in DataService.swift.
//                        DataService.dataService.createNewAccount(authData.uid, user: user)
//                    })
//
//                    // Store the uid for future access - handy!
//                    NSUserDefaults.standardUserDefaults().setValue(result ["uid"], forKey: "uid")
//
//                    // Enter the app.
//                    self.performSegueWithIdentifier("NewUserLoggedIn", sender: nil)
//                }
//            })
            
        } else {
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
    
    @IBAction func cancelCreateAccount(sender: AnyObject) {
        self.dismiss(animated: true, completion: {})
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}
