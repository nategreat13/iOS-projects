//
//  Enemy.swift
//  SportSportShooter
//
//  Created by Nate Gygi on 4/28/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

// Class to represent an enemy, subclass of character
class Enemy: Character {
    
    // Enemy's health
    var health: Int
    
    // Default initializer
    override init() {
        health = 100
        super.init()
    }
    
    // Main initializer for new enemy with full health
    override init(position: CGPoint, velocity: (xVel: CGFloat, yVel: CGFloat), image: UIImage, radius: CGFloat) {
        health = 100
        super.init(position: position, velocity: velocity, image: image, radius: radius)
    }
    
    // Initializer with health
    init(position: CGPoint, velocity: (xVel: CGFloat, yVel: CGFloat), image: UIImage, radius: CGFloat, health: Int) {
        self.health = health
        super.init(position: position, velocity: velocity, image: image, radius: radius)
    }
    
    // Save the enemy to the database for the user with the given email
    func saveToDatabaseFor(email: String, number: Int) {
        // Save the position
        DB.database.child("Users/\(email.replacingOccurrences(of: ".", with: ""))/Game/Enemies/\(number)/Position").updateChildValues(["x": position.x, "y": position.y])
        // Save the velocity
        DB.database.child("Users/\(email.replacingOccurrences(of: ".", with: ""))/Game/Enemies/\(number)/Velocity").updateChildValues(["x": velocity.xVel, "y": velocity.yVel])
        // Save the radius
        DB.database.child("Users/\(email.replacingOccurrences(of: ".", with: ""))/Game/Enemies/\(number)").updateChildValues(["Radius": radius])
        // Save the health
        DB.database.child("Users/\(email.replacingOccurrences(of: ".", with: ""))/Game/Enemies/\(number)").updateChildValues(["Health": health])
    }
    
}
