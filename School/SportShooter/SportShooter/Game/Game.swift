//
//  Game.swift
//  SportSportShooter
//
//  Created by Nate Gygi on 4/28/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

// GameDelegate Protocol
protocol GameDelegate: class {
    // Adds a ball to the game
    func addBall(ball: Ball)
    
    // Gets the frame for the gameView
    func getGameFrame() -> (width: CGFloat, height: CGFloat)
    
    // Tells the delegate that the palyers health has changed
    func healthChanged()
    
    // Tells the delegate to remove the specified inageView
    func removeImageView(imageView: UIImageView)
    
    // Tells the delegate the current level is completed
    func levelFinished()
    
    // Tells the delegate the game is over
    func gameOver()
}

// The model to represent a game
class Game {
    
    // Delegate
    weak var delegate: GameDelegate?
    
    // Image names for level 1 characters
    let level1PlayerImageName = "SoccerStanding"
    let level1PlayerRunningImageName = "SoccerRunning"
    let level1EnemyImageName = "SoccerBall"
    let level1BallImageName = "SoccerBall"
    
    // Image names for level 2 characters
    let level2PlayerImageName = "FootballStanding"
    let level2PlayerRunningImageName = "FootballRunning"
    let level2EnemyImageName = "Football"
    let level2BallImageName = "Football"
    
    // Image names for level 3 characters
    let level3PlayerImageName = "BasketballStanding"
    let level3PlayerRunningImageName = "BasketballRunning"
    let level3EnemyImageName = "Basketball"
    let level3BallImageName = "Basketball"
    
    // The users player
    var player: Player
    // All the enemies
    var enemies: [Enemy]
    // All the balls
    var balls: [Ball]
    // Current level of the game
    var level: Int
    // Time that has passed in the level
    var time: TimeInterval
    // Current score
    var score: Int
    
    // Height and width of the game View
    var height: CGFloat = 0
    var width: CGFloat = 0
    
    // Last execution of the gameLoop
    var lastExecution: Date = Date()
    
    // Represents whether the game is a new or resumed game
    var isNew: Bool = true
    
    // Represents whether the game is a valid game that can be started or resumed
    var isValid = true
    
    // Default initializer
    init() {
        player = Player()
        enemies = []
        balls = []
        level = 1
        time = 0
        score = 0
    }
    
    // Main initializer
    init(player: Player, enemies: [Enemy], balls: [Ball], level: Int, time: TimeInterval, score: Int) {
        self.player = player
        self.enemies = enemies
        self.balls = balls
        self.level = level
        self.time = time
        self.score = score
    }
    
    // Save the game to the database for the user with the given email
    func saveToDatabaseFor(email: String) {
        // Save the level
        DB.database.child("Users/\(email.replacingOccurrences(of: ".", with: ""))/Game").updateChildValues(["Level": level])
        // Save the time
        DB.database.child("Users/\(email.replacingOccurrences(of: ".", with: ""))/Game").updateChildValues(["Time": time])
        // Save the score
        DB.database.child("Users/\(email.replacingOccurrences(of: ".", with: ""))/Game").updateChildValues(["Score": score])
        // Save the player
        player.saveToDatabaseFor(email: email)
        var i: Int = 0
        DB.database.child("Users/\(email.replacingOccurrences(of: ".", with: ""))/Game").updateChildValues(["Enemies": " "])
        // Save each enemy
        for enemy in enemies {
            enemy.saveToDatabaseFor(email: email, number: i)
            i += 1
        }
        DB.database.child("Users/\(email.replacingOccurrences(of: ".", with: ""))/Game/Enemies").updateChildValues(["Count": i])
        DB.database.child("Users/\(email.replacingOccurrences(of: ".", with: ""))/Game").updateChildValues(["Balls": " "])
        i = 0
        // Save each ball
        for ball in balls {
            ball.saveToDatabaseFor(email: email, number: i)
            i += 1
        }
        DB.database.child("Users/\(email.replacingOccurrences(of: ".", with: ""))/Game/Balls").updateChildValues(["Count": i])
        // Load the game into DB as the current saved game
        DB.loadSavedGameFor(email: DB.currentEmail)
    }
    
    // Game loop called frequently to update the state of the game
    func gameLoop() {
        // Get the elapsed time since last execution
        let elapsedTime = Date().timeIntervalSince(lastExecution)
        
        // Update the time passed
        time += elapsedTime
        
        // If 30 seconds have passed in the level, the level is complete, so tell the delegate
        if (time > 30) {
            delegate!.levelFinished()
        }
        // Move the player
        player.move(time: elapsedTime)
        
        // Move each enemy
        for enemy in enemies {
            enemy.move(time: elapsedTime)
        }
        
        // Move each ball
        for ball in balls {
            ball.move(time: elapsedTime)
        }
        
        // Check for player collisions
        if enemies.count > 0 {
            for i in 0...enemies.count-1 {
                // If there is a collision
                if (enemies[i].collidesWith(pos: player.position, rad: player.radius)) {
                    // Remove the enemy
                    delegate!.removeImageView(imageView: enemies[i].image)
                    enemies.remove(at: i)
                    
                    // Decrease the players health and tell the delegate
                    player.health -= 25
                    delegate!.healthChanged()
                    
                    // Check if the player has lost all of their health
                    if (player.health == 0) {
                        delegate!.gameOver()
                    }
                    break
                }
            }
        }
        
        // Check for ball collisions
        var ballCount = balls.count
        var enemyCount = enemies.count
        
        if ballCount > 0 && enemyCount > 0 {
            for i in 0...ballCount-1 {
                if i < balls.count {
                    let ball = balls[i]
                    for j in 0...enemyCount-1 {
                        if j < enemies.count {
                            let enemy = enemies[j]
                            // If there is a collision
                            if ball.collidesWith(pos: enemy.position, rad: enemy.radius) {
                                // Remove the ball
                                delegate!.removeImageView(imageView: balls[i].image)
                                balls.remove(at: i)
                                
                                // Deal the damage to the enemy based on its current size
                                switch enemy.radius {
                                case 150:
                                    enemy.radius = 125
                                    score += 25
                                    break
                                case 125:
                                    enemy.radius = 100
                                    score += 25
                                    break
                                case 100:
                                    enemy.radius = 75
                                    score += 25
                                    break
                                case 75:
                                    enemy.radius = 50
                                    score += 25
                                    break
                                case 50:
                                    enemy.radius = 40
                                    score += 10
                                    break
                                case 40:
                                    enemy.radius = 30
                                    score += 10
                                    break
                                case 30:
                                    enemy.radius = 20
                                    score += 10
                                    break
                                case 20:
                                    enemy.radius = 0
                                    score += 20
                                default:
                                    print("Error")
                                }
                                // If the enemy's radius is now 0, it is dead, so remove it
                                if enemy.radius == 0 {
                                    delegate!.removeImageView(imageView: enemy.image)
                                    enemies.remove(at: j)
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // For each ball that leaves the gameView, tell the delegate to remove it
        ballCount = balls.count
        if ballCount > 0 {
            for i in 0...ballCount-1 {
                if i < balls.count {
                    if balls[i].position.y < 0 {
                        delegate!.removeImageView(imageView: balls[i].image)
                        balls.remove(at: i)
                    }
                }
            }
        }
        
        // For each enemy that leaves the gameView, tell the delegate to remove it
        enemyCount = enemies.count
        if enemyCount > 0 {
            for i in 0...enemyCount-1 {
                if i < enemies.count {
                    if enemies[i].position.y - enemies[i].radius > height {
                        delegate!.removeImageView(imageView: enemies[i].image)
                        enemies.remove(at: i)
                    }
                }
            }
        }
        
        // Update the last execution
        lastExecution = Date()
    }
    
    // Add a ball that was shot
    func addBall() {
        // Add a ball that starts right above the player and moves up. Set the image depending on the level
        if level == 1 {
            let ball = Ball(position: CGPoint(x: player.position.x, y: player.position.y - player.radius - 10), velocity: (0.0, -100.0), image: UIImage(named: level1BallImageName)!, radius: 5)
            balls.append(ball)
            // Tell the delegate
            delegate!.addBall(ball: ball)
        }
        else if level == 2 {
            let ball = Ball(position: CGPoint(x: player.position.x, y: player.position.y - player.radius - 10), velocity: (0.0, -100.0), image: UIImage(named: level2BallImageName)!, radius: 5)
            balls.append(ball)
            // Tell the delegate
            delegate!.addBall(ball: ball)
        }
        else if level == 3 {
            let ball = Ball(position: CGPoint(x: player.position.x, y: player.position.y - player.radius - 10), velocity: (0.0, -100.0), image: UIImage(named: level3BallImageName)!, radius: 5)
            balls.append(ball)
            // Tell the delegate
            delegate!.addBall(ball: ball)
        }
    }
    
    // Setup level 1
    func setupLevel1() {
        // Get the width and height
        (width, height) = delegate!.getGameFrame()
        
        // Position the player at the starting point
        player.position = CGPoint(x: width/2, y: height - 50)
        // Set the player's image, radius, and velocity (not moving)
        player.image.image = UIImage(named: level1PlayerImageName)
        player.radius = 30
        player.velocity = (0.0, 0.0)
        
        // Add Enemies (Scripted) They start way above the game View frame and move down into it at a game time
        enemies.append(Enemy(position: CGPoint(x: width/2, y: -100), velocity: (0.0, 200.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: width/4, y: -200), velocity: (0.0, 200.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 3*width/4, y: -200), velocity: (0.0, 200.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: width/5, y: -400), velocity: (0.0, 100.0), image: UIImage(named: level1EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: -100, y: -200), velocity: (50.0, 75.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 2*width/3, y: -2000), velocity: (0.0, 150.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: width/2, y: -100), velocity: (0.0, 50.0), image: UIImage(named: level1EnemyImageName)!, radius: 50))
        enemies.append(Enemy(position: CGPoint(x: width/5, y: -2000), velocity: (0.0, 100.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: -500, y: -1000), velocity: (50.0, 75.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: width/3, y: -3000), velocity: (0.0, 150.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: width/2, y: -3000), velocity: (0.0, 150.0), image: UIImage(named: level1EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 2*width/3, y: -3000), velocity: (0.0, 150.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: width/5, y: -2000), velocity: (0.0, 100.0), image: UIImage(named: level1EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 2*width/5, y: -2000), velocity: (0.0, 100.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 3*width/5, y: -2000), velocity: (0.0, 100.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 4*width/5, y: -2000), velocity: (0.0, 100.0), image: UIImage(named: level1EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: width/6, y: -5000), velocity: (0.0, 200.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 2*width/6, y: -5000), velocity: (0.0, 200.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 3*width/6, y: -5000), velocity: (0.0, 200.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 4*width/6, y: -5000), velocity: (0.0, 200.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 5*width/6, y: -5000), velocity: (0.0, 200.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: -1200, y: -2400), velocity: (100.0, 200.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: -1100, y: -2400), velocity: (100.0, 200.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: -1000, y: -2400), velocity: (100.0, 200.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 1500 + width, y: -3000), velocity: (-100.0, 200.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 1400 + width, y: -3000), velocity: (-100.0, 200.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 1300 + width, y: -3000), velocity: (-100.0, 200.0), image: UIImage(named: level1EnemyImageName)!, radius: 30))
        
    }
    
    func setupLevel2() {
        // Get teh width and the height
        (width, height) = delegate!.getGameFrame()
        
        // Get the health of the player to initialize the player for level 2
        let health = player.health
        
        // Create the player with the new image for level 2
        player = Player(position: CGPoint(x: width/2, y: height - 50), velocity: (0.0, 0.0), image: UIImage(named: level2PlayerImageName)!, radius: 30)
        player.health = health
        
        // Reset enemies, balls, and time
        enemies = []
        balls = []
        time = 0
        
        // Add Enemies (Scripted) They start way above the game View frame and move down into it at a game time
        enemies.append(Enemy(position: CGPoint(x: width/2, y: -400), velocity: (0.0, 100.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 4*width/10, y: -450), velocity: (0.0, 100.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 6*width/10, y: -450), velocity: (0.0, 100.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 3*width/10, y: -500), velocity: (0.0, 100.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 7*width/10, y: -500), velocity: (0.0, 100.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 2*width/10, y: -550), velocity: (0.0, 100.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 8*width/10, y: -550), velocity: (0.0, 100.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 1*width/10, y: -600), velocity: (0.0, 100.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 9*width/10, y: -600), velocity: (0.0, 100.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 5*width/10, y: -600), velocity: (0.0, 100.0), image: UIImage(named: level2EnemyImageName)!, radius: 50))
        enemies.append(Enemy(position: CGPoint(x: 2*width/10, y: -650), velocity: (0.0, 100.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 8*width/10, y: -650), velocity: (0.0, 100.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 3*width/10, y: -700), velocity: (0.0, 100.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 7*width/10, y: -700), velocity: (0.0, 100.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 4*width/10, y: -750), velocity: (0.0, 100.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 6*width/10, y: -750), velocity: (0.0, 100.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: width/2, y: -800), velocity: (0.0, 100.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        
        
        enemies.append(Enemy(position: CGPoint(x: 1*width/10, y: -2200), velocity: (0.0, 200.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 2*width/10, y: -2300), velocity: (0.0, 200.0), image: UIImage(named: level2EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 3*width/10, y: -2400), velocity: (0.0, 200.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 4*width/10, y: -2500), velocity: (0.0, 200.0), image: UIImage(named: level2EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 5*width/10, y: -2600), velocity: (0.0, 200.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 6*width/10, y: -2700), velocity: (0.0, 200.0), image: UIImage(named: level2EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 7*width/10, y: -2800), velocity: (0.0, 200.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 8*width/10, y: -2900), velocity: (0.0, 200.0), image: UIImage(named: level2EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 9*width/10, y: -3000), velocity: (0.0, 200.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 8*width/10, y: -3100), velocity: (0.0, 200.0), image: UIImage(named: level2EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 7*width/10, y: -3200), velocity: (0.0, 200.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 6*width/10, y: -3300), velocity: (0.0, 200.0), image: UIImage(named: level2EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 5*width/10, y: -3400), velocity: (0.0, 200.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 4*width/10, y: -3500), velocity: (0.0, 200.0), image: UIImage(named: level2EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 3*width/10, y: -3600), velocity: (0.0, 200.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 2*width/10, y: -3700), velocity: (0.0, 200.0), image: UIImage(named: level2EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 1*width/10, y: -3800), velocity: (0.0, 200.0), image: UIImage(named: level2EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: width/2, y: -5500), velocity: (0.0, 250.0), image: UIImage(named: level2EnemyImageName)!, radius: 100))
        enemies.append(Enemy(position: CGPoint(x: width/3, y: -5700), velocity: (0.0, 250.0), image: UIImage(named: level2EnemyImageName)!, radius: 100))
        enemies.append(Enemy(position: CGPoint(x: 2*width/3, y: -5700), velocity: (0.0, 250.0), image: UIImage(named: level2EnemyImageName)!, radius: 100))
    }
    
    func setupLevel3() {
        
        // Get the width and height
        (width, height) = delegate!.getGameFrame()
        
        // Get the health of the player to initialize the player for level 2
        let health = player.health
        
        // Create the player with the new image for level 3
        player = Player(position: CGPoint(x: width/2, y: height - 50), velocity: (0.0, 0.0), image: UIImage(named: level3PlayerImageName)!, radius: 30)
        player.health = health
        
        // Reset the enemies, balls, and time
        enemies = []
        balls = []
        time = 0
        
        // Add Enemies (Scripted) They start way above the game View frame and move down into it at a game time
        enemies.append(Enemy(position: CGPoint(x: 1*width/10, y: -400), velocity: (0.0, 100.0), image: UIImage(named: level3EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 9*width/10, y: -400), velocity: (0.0, 100.0), image: UIImage(named: level3EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 5*width/10, y: -400), velocity: (0.0, 100.0), image: UIImage(named: level3EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 3*width/10, y: -500), velocity: (0.0, 100.0), image: UIImage(named: level3EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 7*width/10, y: -500), velocity: (0.0, 100.0), image: UIImage(named: level3EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 1*width/10, y: -600), velocity: (0.0, 100.0), image: UIImage(named: level3EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 9*width/10, y: -600), velocity: (0.0, 100.0), image: UIImage(named: level3EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 5*width/10, y: -600), velocity: (0.0, 100.0), image: UIImage(named: level3EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 3*width/10, y: -700), velocity: (0.0, 100.0), image: UIImage(named: level3EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 7*width/10, y: -700), velocity: (0.0, 100.0), image: UIImage(named: level3EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 5*width/10, y: -1000), velocity: (0.0, 100.0), image: UIImage(named: level3EnemyImageName)!, radius: 100))
        enemies.append(Enemy(position: CGPoint(x: 1*width/4, y: -1200), velocity: (0.0, 100.0), image: UIImage(named: level3EnemyImageName)!, radius: 100))
        enemies.append(Enemy(position: CGPoint(x: 3*width/4, y: -1200), velocity: (0.0, 100.0), image: UIImage(named: level3EnemyImageName)!, radius: 100))
        enemies.append(Enemy(position: CGPoint(x: 5*width/10, y: -1400), velocity: (0.0, 100.0), image: UIImage(named: level3EnemyImageName)!, radius: 100))
        enemies.append(Enemy(position: CGPoint(x: 2*width/10, y: -5100), velocity: (0.0, 300.0), image: UIImage(named: level3EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 4*width/10, y: -5100), velocity: (0.0, 300.0), image: UIImage(named: level3EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 6*width/10, y: -5100), velocity: (0.0, 300.0), image: UIImage(named: level3EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 8*width/10, y: -5100), velocity: (0.0, 300.0), image: UIImage(named: level3EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: -2000, y: -4000), velocity: (100.0, 200.0), image: UIImage(named: level3EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 2000 + width, y: -4000), velocity: (-100.0, 200.0), image: UIImage(named: level3EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 1*width/4, y: -4200), velocity: (0.0, 200.0), image: UIImage(named: level3EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 3*width/4, y: -4200), velocity: (0.0, 200.0), image: UIImage(named: level3EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: -2300, y: -4600), velocity: (100.0, 200.0), image: UIImage(named: level3EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 2300 + width, y: -4600), velocity: (-100.0, 200.0), image: UIImage(named: level3EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 1*width/4, y: -4800), velocity: (0.0, 200.0), image: UIImage(named: level3EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 3*width/4, y: -4800), velocity: (0.0, 200.0), image: UIImage(named: level3EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 2*width/4, y: -5200), velocity: (0.0, 200.0), image: UIImage(named: level3EnemyImageName)!, radius: 150))
    }
    
    // Change the image to the standing version based on the level
    func changeImageToStanding() {
        if level == 1 {
            player.image.image = UIImage(named: level1PlayerImageName)
        }
        else if level == 2 {
            player.image.image = UIImage(named: level2PlayerImageName)
        }
        else if level == 3 {
            player.image.image = UIImage(named: level3PlayerImageName)
        }
    }
    
    // Change the image to the running version based on the level
    func changeImageToRunning() {
        if level == 1 {
            player.image.image = UIImage(named: level1PlayerRunningImageName)
        }
        else if level == 2 {
            player.image.image = UIImage(named: level2PlayerRunningImageName)
        }
        else if level == 3 {
            player.image.image = UIImage(named: level3PlayerRunningImageName)
        }
    }
    
}
