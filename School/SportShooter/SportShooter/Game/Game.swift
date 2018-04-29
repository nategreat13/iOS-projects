//
//  Game.swift
//  SportSportShooter
//
//  Created by Nate Gygi on 4/28/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class Game {
    
    var player: Player
    var enemies: [Enemy]
    var balls: [Ball]
    var level: Int
    
    
    init() {
        player = Player()
        enemies = []
        balls = []
        level = 1
    }
    
    init(player: Player, enemies: [Enemy], balls: [Ball], level: Int) {
        self.player = player
        self.enemies = enemies
        self.balls = balls
        self.level = level
    }
    
    func gameLoop() {
        
    }
    
    func displayLoop() {
        
    }
    
}
