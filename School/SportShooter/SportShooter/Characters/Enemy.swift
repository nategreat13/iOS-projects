//
//  Enemy.swift
//  SportSportShooter
//
//  Created by Nate Gygi on 4/28/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class Enemy: Character {
    
    var health: Int
    
    override init() {
        health = 100
        super.init()
    }
    
    override init(position: CGPoint, velocity: (xVel: CGFloat, yVel: CGFloat), image: UIImage, radius: CGFloat) {
        health = 100
        super.init(position: position, velocity: velocity, image: image, radius: radius)
    }
    
}
