//
//  Character.swift
//  SportSportShooter
//
//  Created by Nate Gygi on 4/28/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class Character {
    
    var position: CGPoint
    var velocity: (xVel: CGFloat, yVel: CGFloat)
    var image: UIImage
    var radius: CGFloat
    
    init() {
        position = CGPoint(x: 0.0, y: 0.0)
        velocity = (0.0, 0.0)
        image = UIImage()
        radius = 0.0
    }
    
    init(position: CGPoint, velocity: (xVel: CGFloat, yVel: CGFloat), image: UIImage, radius: CGFloat) {
        self.position = position
        self.velocity = velocity
        self.image = image
        self.radius = radius
    }
    
    func move(time: TimeInterval) {
        position = CGPoint(x: position.x + velocity.xVel * CGFloat(time), y: position.y + velocity.yVel * CGFloat(time))
    }
    
    func collidesWith(pos: CGPoint, rad: CGFloat) -> Bool {
        return distance(pos1: position, pos2: pos) <= rad + radius
    }
    
    func distance(pos1: CGPoint, pos2: CGPoint) -> CGFloat {
        return sqrt(pow(pos1.x - pos2.x, 2) + pow(pos1.y - pos2.y, 2))
    }
    
    func setVelocity(xVel: CGFloat, yVel: CGFloat) {
        velocity.xVel = xVel
        velocity.yVel = yVel
    }
}
