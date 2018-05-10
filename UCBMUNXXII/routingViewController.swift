//
//  routingViewController.swift
//  UCBMUNXXII
//
//  Created by Nikhil Gahlot on 2/20/18.
//  Copyright © 2018 UCBMUN. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class routingViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
//        if (Auth.auth().currentUser != nil){
//            self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
//        }else{
//            self.performSegue(withIdentifier: "toLogIn", sender: nil)
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
                            self.performSegue(withIdentifier: "alreadyLoggedIn", sender: nil)
            }
            else{
                self.performSegue(withIdentifier: "toLogIn", sender: nil)
            }
        }
    }
}
