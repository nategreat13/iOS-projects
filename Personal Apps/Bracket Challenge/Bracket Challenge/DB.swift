//
//  DB.swift
//  Bracket Challenge
//
//  Created by Nate Gygi on 5/16/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import Foundation
import Firebase

class DB {

    // Reference to the Firebase database
    public static var database: DatabaseReference = DatabaseReference()
    
    // Username of the currently logged in user
    public static var currentUsername: String = String()
    
    // Email of the currently logged in user
    public static var currentEmail: String = String()
}
