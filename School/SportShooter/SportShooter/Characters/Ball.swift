//
//  Ball.swift
//  SportSportShooter
//
//  Created by Nate Gygi on 4/28/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

// Represents a ball that is shot at an enemy. Subclass of character
class Ball: Character {
    
    // Default init
    override init() {
        super.init()
    }
    
    // Main init
    override init(position: CGPoint, velocity: (xVel: CGFloat, yVel: CGFloat), image: UIImage, radius: CGFloat) {
        super.init(position: position, velocity: velocity, image: image, radius: radius)
    }
    
    // Save ball to database for the user with the given email
    func saveToDatabaseFor(email: String, number: Int) {
        // Save the position
        DB.database.child("Users/\(email.replacingOccurrences(of: ".", with: ""))/Game/Balls/\(number)/Position").updateChildValues(["x": position.x, "y": position.y])
        // Save the velocity
        DB.database.child("Users/\(email.replacingOccurrences(of: ".", with: ""))/Game/Balls/\(number)/Velocity").updateChildValues(["x": velocity.xVel, "y": velocity.yVel])
        // Save the radius
        DB.database.child("Users/\(email.replacingOccurrences(of: ".", with: ""))/Game/Balls/\(number)").updateChildValues(["Radius": radius])
    }
    
}
