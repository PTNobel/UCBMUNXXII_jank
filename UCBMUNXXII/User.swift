//
//  User.swift
//  UCBMUNXXII
//
//  Created by Nikhil Gahlot on 2/16/18.
//  Copyright © 2018 UCBMUN. All rights reserved.
//


import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    
    init(authData: User) {
        uid = authData.uid
        email = authData.email
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}
