//
//  Post.swift
//  UCBMUNXXII
//
//  Created by Nikhil Gahlot on 2/16/18.
//  Copyright © 2018 UCBMUN. All rights reserved.
//

import Foundation
import Firebase

class Post {
    private var __postKey: String!
    private var __postText: String!
    private var __postVotes: Int!
    private var __username: String!
    private var __upvoters: [String]!
    private var __downvoters: [String]!
    let ref: DatabaseReference?
    
    var postKey: String {
        return __postKey
    }
    
    var postText: String {
        return __postText
    }
    
    var postVotes: Int {
        return __postVotes
    }
    
    var username: String {
        return __username
    }
    
    var upvoters: [String] {
        return __upvoters
    }
    
    var downvoters: [String] {
        return __downvoters
    }
    
    func toAnyObject() -> Any {
        return [
            "text": __postText,
            "author": __username,
            "votes": __postVotes,
            "key": __postKey,
            "upvoters":__upvoters,
            "downvoters":__downvoters
        ]
    }
    
    init(snapshot: DataSnapshot) {
        __postKey = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        __postText = snapshotValue["text"] as! String
        __username = snapshotValue["author"] as! String
        __postVotes = snapshotValue["votes"] as! Int
        __upvoters = snapshotValue["upvoters"] as! [String]
        __downvoters = snapshotValue["downvoters"] as! [String]
        ref = snapshot.ref
    }
    
    init(key:String, text:String, author:String, votes: Int) {
        self.__postKey = key
        self.__postText = text
        self.__username = author
        self.__postVotes = votes
        self.__upvoters = [""]
        self.__downvoters = [""]
        
        self.ref = nil
    }
//    init(key: String, dictionary: Dictionary<String, AnyObject>) {
//        self.__postKey = key
//
//        // Within the Post, or Key, the following properties are children
//
//        if let votes = dictionary["votes"] as? Int {
//            self.__postVotes = votes
//        }
//
//        if let joke = dictionary["jokeText"] as? String {
//            self.__postText = joke
//        }
//
//        if let user = dictionary["author"] as? String {
//            self.__username = user
//        } else {
//            self.__username = ""
//        }
//
//        // The above properties are assigned to their key.
//    }
    
}
