//
//  DataService.swift
//  NikolaSocialMed
//
//  Created by Nikola Tosic on 7/18/17.
//  Copyright © 2017 Nikola Tosic. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference() // <- Url from GoogleSerice (https://nikolasocilamed.firebaseio.com)

class DataService {
    
    static let ds = DataService() // <-Singleton
    
    private var _REF_BASE = DB_BASE
    private var _REF_POSTS = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_POSTS: DatabaseReference {
        return _REF_POSTS
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, String>) {
        // uid is name of hub // userData is content of hub
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    
    
    
    
    
    
    
    
    
    
}
