//
//  Ball.swift
//  SportSportShooter
//
//  Created by Nate Gygi on 4/28/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class Ball: Character {
    
    
    override init() {
        super.init()
    }
    
    override init(position: CGPoint, velocity: (xVel: CGFloat, yVel: CGFloat), image: UIImage, radius: CGFloat) {
        super.init(position: position, velocity: velocity, image: image, radius: radius)
    }
    
}
