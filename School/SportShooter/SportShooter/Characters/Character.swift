//
//  Character.swift
//  SportSportShooter
//
//  Created by Nate Gygi on 4/28/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

// Character superclass for the game
class Character
{
    
    // Current position
    var position: CGPoint
    // Current velocity
    var velocity: (xVel: CGFloat, yVel: CGFloat)
    // Image
    var image: UIImageView
    // Radius
    var radius: CGFloat
    
    // Default initializer
    init() {
        position = CGPoint(x: 0.0, y: 0.0)
        velocity = (0.0, 0.0)
        image = UIImageView()
        radius = 0.0
    }
    
    // Main initializer
    init(position: CGPoint, velocity: (xVel: CGFloat, yVel: CGFloat), image: UIImage, radius: CGFloat) {
        self.position = position
        self.velocity = velocity
        self.image = UIImageView(image: image)
        self.radius = radius
    }
    
    // Update the character's position based on its current positition and velocity
    func move(time: TimeInterval) {
        position = CGPoint(x: position.x + velocity.xVel * CGFloat(time), y: position.y + velocity.yVel * CGFloat(time))
    }
    
    // Check if the character collides with another based on poition and radius
    func collidesWith(pos: CGPoint, rad: CGFloat) -> Bool {
        return distance(pos1: position, pos2: pos) <= rad + radius
    }
    
    // Returns the distance between two points
    func distance(pos1: CGPoint, pos2: CGPoint) -> CGFloat {
        return sqrt(pow(pos1.x - pos2.x, 2) + pow(pos1.y - pos2.y, 2))
    }
    
    // Set the character's velocity
    func setVelocity(xVel: CGFloat, yVel: CGFloat) {
        velocity.xVel = xVel
        velocity.yVel = yVel
    }
}
