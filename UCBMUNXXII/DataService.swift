//
//  DataService.swift
//  UCBMUNXXII
//
//  Created by Nikhil Gahlot on 2/16/18.
//  Copyright © 2018 UCBMUN. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class DataService {


    static let dataService = DataService()

    private var _BASE_REF: DatabaseReference = Database.database().reference(fromURL: "https://ucbmunxxii.firebaseapp.com/")
    private var _USER_REF:DatabaseReference = Database.database().reference(fromURL: "https://ucbmunxxii.firebaseapp.com/users")//Datbase(url: "\(BASE_URL)/users")
    private var _POST_REF: DatabaseReference = Database.database().reference(fromURL: "https://ucbmunxxii.firebaseapp.com/posts")//Datbase(url: "\(BASE_URL)/posts")

    var BASE_REF: DatabaseReference {
        return _BASE_REF
    }

    var USER_REF: DatabaseReference {
        return _USER_REF
    }

    var CURRENT_USER_REF: DatabaseReference {
        let userID = UserDefaults.standard.value(forKey: "uid") as! String

        let currentUser = Database.database().reference(fromURL: "\(BASE_REF)").child(byAppendingPath: "users").child(byAppendingPath: userID)

        return currentUser
    }

    var POST_REF: DatabaseReference {
        return _POST_REF
    }
    
    
//    func createNewAccount(uid: String, user: Dictionary<String, String>) {
//        
//        // A User is born.
//        
//        USER_REF.childByAppendingPath(uid).setValue(user)
//    }
}

