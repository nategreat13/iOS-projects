//
//  DB.swift
//  SportSportShooter
//
//  Created by Nate Gygi on 5/1/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import Foundation
import Firebase

// A class to hold global variables for easy access from within the other parts of code
class DB {
    
    // Level 1 image names for characters
    public static let level1PlayerImageName = "SoccerStanding"
    public static let level1EnemyImageName = "SoccerBall"
    public static let level1BallImageName = "SoccerBall"
    
    // Level 2 image names for characters
    public static let level2PlayerImageName = "FootballStanding"
    public static let level2EnemyImageName = "Football"
    public static let level2BallImageName = "Football"
    
    // Level 3 image names for characters
    public static let level3PlayerImageName = "BasketballStanding"
    public static let level3EnemyImageName = "Basketball"
    public static let level3BallImageName = "Basketball"
    
    // Reference to the Firebase database
    public static var database: DatabaseReference = DatabaseReference()
    
    // Current high scores
    public static var highScores: HighScores = HighScores()
    
    // Username of the currently logged in user
    public static var currentUsername: String = String()
    
    // Email of the currently logged in user
    public static var currentEmail: String = String()
    
    // Most recent saved game for the current user
    public static var savedGame: Game = Game()
    
    // Load the saved game for the user with given email
    public static func loadSavedGameFor(email: String) {
        //Ask the database for the user's game info
        DB.database.child("Users/\(email.replacingOccurrences(of: ".", with: ""))/Game").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary ?? [:]
            // Cast the proprties to dictionaries and other values to use
            let score: Int = value["Score"] as? Int ?? 0
            let level: Int = value["Level"] as? Int ?? 1
            let time: TimeInterval = value["Time"] as? TimeInterval ?? 0
            let playerData = value["Player"] as? NSDictionary ?? [:]
            let enemyData = value["Enemies"] as? NSDictionary ?? [:]
            let ballsData = value["Balls"] as? NSDictionary ?? [:]
            
            // Get the position of the player
            var position = playerData["Position"] as? NSDictionary ?? [:]
            var positionx = position["x"] as? CGFloat ?? 0.0
            var positiony = position["y"] as? CGFloat ?? 0.0
            
            // Get the velocity of the player
            var velocity = playerData["Velocity"] as? NSDictionary ?? [:]
            var velocityx = velocity["x"] as? CGFloat ?? 0.0
            var velocityy = velocity["y"] as? CGFloat ?? 0.0
            
            // Get the radius of the player
            var radius = playerData["Radius"] as? CGFloat ?? 0
            
            // Get the health of the player
            var health = playerData["Health"] as? Int ?? 0
            var player = Player()
            
            // Based on the level (because of the image), initalize a player from the database values
            if level == 1 {
                player = Player(position: CGPoint(x: positionx, y: positiony), velocity: (velocityx, velocityy), image: UIImage(named: level1PlayerImageName)!, radius: radius, health: health)
            }
            else if level == 2 {
                player = Player(position: CGPoint(x: positionx, y: positiony), velocity: (velocityx, velocityy), image: UIImage(named: level2PlayerImageName)!, radius: radius, health: health)
            }
            else {
                player = Player(position: CGPoint(x: positionx, y: positiony), velocity: (velocityx, velocityy), image: UIImage(named: level3PlayerImageName)!, radius: radius, health: health)
            }
            
            var enemies: [Enemy] = []
            
            // For each enemy
            for value in enemyData {
                let key = value.key as? String ?? ""
                if key != "Count" {
                    let enemyValues = value.value as? NSDictionary ?? [:]
                    
                    // Get the enemy's position
                    position = enemyValues["Position"] as? NSDictionary ?? [:]
                    positionx = position["x"] as? CGFloat ?? 0.0
                    positiony = position["y"] as? CGFloat ?? 0.0
                    
                    // Get the enemy's velocity
                    velocity = enemyValues["Velocity"] as? NSDictionary ?? [:]
                    velocityx = velocity["x"] as? CGFloat ?? 0.0
                    velocityy = velocity["y"] as? CGFloat ?? 0.0
                    
                    // Get the enemy's radius
                    radius = enemyValues["Radius"] as? CGFloat ?? 0
                    
                    // Get the enemy's health
                    health = enemyValues["Health"] as? Int ?? 0
                    var enemy = Enemy()
                    // Based on the level (because of the image), initalize an enemy from the database values
                    if level == 1 {
                        enemy = Enemy(position: CGPoint(x: positionx, y: positiony), velocity: (velocityx, velocityy), image: UIImage(named: level1EnemyImageName)!, radius: radius, health: health)
                    }
                    else if level == 2 {
                        enemy = Enemy(position: CGPoint(x: positionx, y: positiony), velocity: (velocityx, velocityy), image: UIImage(named: level2EnemyImageName)!, radius: radius, health: health)
                    }
                    else {
                        enemy = Enemy(position: CGPoint(x: positionx, y: positiony), velocity: (velocityx, velocityy), image: UIImage(named: level3EnemyImageName)!, radius: radius, health: health)
                    }
                    // Add the enemy to the set of enemies
                    enemies.append(enemy)
                }
            }
            
            var balls: [Ball] = []
            
            // For each ball
            for value in ballsData {
                let key = value.key as? String ?? ""
                if key != "Count" {
                    let ballValues = value.value as? NSDictionary ?? [:]
                    
                    // Get the ball's position
                    position = ballValues["Position"] as? NSDictionary ?? [:]
                    positionx = position["x"] as? CGFloat ?? 0.0
                    positiony = position["y"] as? CGFloat ?? 0.0
                    
                    // Get the ball's velocity
                    velocity = ballValues["Velocity"] as? NSDictionary ?? [:]
                    velocityx = velocity["x"] as? CGFloat ?? 0.0
                    velocityy = velocity["y"] as? CGFloat ?? 0.0
                    
                    // Get the ball's radius
                    radius = ballValues["Radius"] as? CGFloat ?? 0
                    var ball = Ball()
                    // Based on the level (because of the image), initalize a ball from the database values
                    if level == 1 {
                        ball = Ball(position: CGPoint(x: positionx, y: positiony), velocity: (velocityx, velocityy), image: UIImage(named: level1BallImageName)!, radius: radius)
                    }
                    else if level == 2 {
                        ball = Ball(position: CGPoint(x: positionx, y: positiony), velocity: (velocityx, velocityy), image: UIImage(named: level2BallImageName)!, radius: radius)
                    }
                    else {
                        ball = Ball(position: CGPoint(x: positionx, y: positiony), velocity: (velocityx, velocityy), image: UIImage(named: level2BallImageName)!, radius: radius)
                    }
                    // Add the ball
                    balls.append(ball)
                }
            }
            // Set the savedGame to a game that is initialized from the values from the database
            DB.savedGame = Game(player: player, enemies: enemies, balls: balls, level: level, time: time, score: score)
            
        })
    }
    
}
