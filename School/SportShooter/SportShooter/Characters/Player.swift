//
//  Player.swift
//  SportSportShooter
//
//  Created by Nate Gygi on 4/28/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

// Represents a player that the user controls. Is a subclass of character
class Player: Character {
    
    // Player's current health
    var health: Int
    
    // Default initializer
    override init() {
        health = 100
        super.init()
    }
    
    // Main initlizer for new player with full health
    override init(position: CGPoint, velocity: (xVel: CGFloat, yVel: CGFloat), image: UIImage, radius: CGFloat) {
        health = 100
        super.init(position: position, velocity: velocity, image: image, radius: radius)
    }
    
    // Initalizer with health
    init(position: CGPoint, velocity: (xVel: CGFloat, yVel: CGFloat), image: UIImage, radius: CGFloat, health: Int) {
        self.health = health
        super.init(position: position, velocity: velocity, image: image, radius: radius)
    }
    
    // Save the player to the database for the user with the given email
    func saveToDatabaseFor(email: String) {
        // Save the position
        DB.database.child("Users/\(email.replacingOccurrences(of: ".", with: ""))/Game/Player/Position").updateChildValues(["x": position.x, "y": position.y])
        // Save the velocity
        DB.database.child("Users/\(email.replacingOccurrences(of: ".", with: ""))/Game/Player/Velocity").updateChildValues(["x": velocity.xVel, "y": velocity.yVel])
        // Save the radius
        DB.database.child("Users/\(email.replacingOccurrences(of: ".", with: ""))/Game/Player").updateChildValues(["Radius": radius])
        // Save the health
        DB.database.child("Users/\(email.replacingOccurrences(of: ".", with: ""))/Game/Player").updateChildValues(["Health": health])
    }
    
}
