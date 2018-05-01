//
//  Game.swift
//  SportSportShooter
//
//  Created by Nate Gygi on 4/28/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

protocol GameDelegate: class {
    func addBall(ball: Ball)
    func getGameFrame() -> (width: CGFloat, height: CGFloat)
    func healthChanged()
    func removeImageView(imageView: UIImageView)
    func levelFinished()
    func gameOver()
}

class Game {
    
    weak var delegate: GameDelegate?
    
    let level1PlayerImageName = "SoccerBall"
    let leve11EnemyImageName = "SoccerBall"
    let level1BallImageName = "SoccerBall"
    
    let level2PlayerImageName = "SoccerBall"
    let leve12EnemyImageName = "Basketball"
    let level2BallImageName = "Basketball"
    
    let level3PlayerImageName = "SoccerBall"
    let level3EnemyImageName = "SoccerBall"
    let level3BallImageName = "SoccerBall"
    
    var player: Player
    var enemies: [Enemy]
    var balls: [Ball]
    var level: Int
    var time: TimeInterval
    var lastExecution: Date = Date()
    var score: Int
    
    var height: CGFloat = 0
    var width: CGFloat = 0
    
    
    init() {
        player = Player()
        enemies = []
        balls = []
        level = 1
        time = 0
        score = 0
    }
    
    init(player: Player, enemies: [Enemy], balls: [Ball], level: Int, time: TimeInterval, score: Int) {
        self.player = player
        self.enemies = enemies
        self.balls = balls
        self.level = level
        self.time = time
        self.score = score
    }
    
    func gameLoop() {
        let elapsedTime = Date().timeIntervalSince(lastExecution)
        time += elapsedTime
        if (time > 30) {
            delegate!.levelFinished()
        }
        player.move(time: elapsedTime)
        for enemy in enemies {
            enemy.move(time: elapsedTime)
        }
        for ball in balls {
            ball.move(time: elapsedTime)
        }
        
        // Check for player collisions
        if enemies.count > 0 {
            for i in 0...enemies.count-1 {
                if (enemies[i].collidesWith(pos: player.position, rad: player.radius)) {
                    delegate!.removeImageView(imageView: enemies[i].image)
                    enemies.remove(at: i)
                    player.health -= 25
                    delegate!.healthChanged()
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
                            if ball.collidesWith(pos: enemy.position, rad: enemy.radius) {
                                delegate!.removeImageView(imageView: balls[i].image)
                                balls.remove(at: i)
                                switch enemy.radius {
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
        
        lastExecution = Date()
    }
    
    func addBall() {
        if level == 1 {
            let ball = Ball(position: CGPoint(x: player.position.x, y: player.position.y - player.radius - 10), velocity: (0.0, -100.0), image: UIImage(named: level1BallImageName)!, radius: 10)
            balls.append(ball)
            delegate!.addBall(ball: ball)
        }
        else if level == 2 {
            let ball = Ball(position: CGPoint(x: player.position.x, y: player.position.y - player.radius - 10), velocity: (0.0, -100.0), image: UIImage(named: level2BallImageName)!, radius: 10)
            balls.append(ball)
            delegate!.addBall(ball: ball)
        }
        else if level == 3 {
            let ball = Ball(position: CGPoint(x: player.position.x, y: player.position.y - player.radius - 10), velocity: (0.0, -100.0), image: UIImage(named: level3BallImageName)!, radius: 10)
            balls.append(ball)
            delegate!.addBall(ball: ball)
        }
    }
    
    func setupLevel1() {
        (width, height) = delegate!.getGameFrame()
        
        player.position = CGPoint(x: width/2, y: height - 50)
        player.image.image = UIImage(named: level1PlayerImageName)
        player.radius = 20
        player.velocity = (0.0, 0.0)
        
        // Add Enemies
        enemies.append(Enemy(position: CGPoint(x: width/2, y: -100), velocity: (0.0, 200.0), image: UIImage(named: leve11EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: width/4, y: -200), velocity: (0.0, 200.0), image: UIImage(named: leve11EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 3*width/4, y: -200), velocity: (0.0, 200.0), image: UIImage(named: leve11EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: width/5, y: -400), velocity: (0.0, 100.0), image: UIImage(named: leve11EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: -100, y: -200), velocity: (50.0, 75.0), image: UIImage(named: leve11EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 2*width/3, y: -2000), velocity: (0.0, 150.0), image: UIImage(named: leve11EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: width/2, y: -100), velocity: (0.0, 50.0), image: UIImage(named: leve11EnemyImageName)!, radius: 50))
        enemies.append(Enemy(position: CGPoint(x: width/5, y: -2000), velocity: (0.0, 100.0), image: UIImage(named: leve11EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: -500, y: -1000), velocity: (50.0, 75.0), image: UIImage(named: leve11EnemyImageName)!, radius: 30))
        
        enemies.append(Enemy(position: CGPoint(x: width/3, y: -3000), velocity: (0.0, 150.0), image: UIImage(named: leve11EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: width/2, y: -3000), velocity: (0.0, 150.0), image: UIImage(named: leve11EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 2*width/3, y: -3000), velocity: (0.0, 150.0), image: UIImage(named: leve11EnemyImageName)!, radius: 30))
        
        enemies.append(Enemy(position: CGPoint(x: width/5, y: -2000), velocity: (0.0, 100.0), image: UIImage(named: leve11EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 2*width/5, y: -2000), velocity: (0.0, 100.0), image: UIImage(named: leve11EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 3*width/5, y: -2000), velocity: (0.0, 100.0), image: UIImage(named: leve11EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 4*width/5, y: -2000), velocity: (0.0, 100.0), image: UIImage(named: leve11EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: width/6, y: -5000), velocity: (0.0, 200.0), image: UIImage(named: leve11EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 2*width/6, y: -5000), velocity: (0.0, 200.0), image: UIImage(named: leve11EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 3*width/6, y: -5000), velocity: (0.0, 200.0), image: UIImage(named: leve11EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 4*width/6, y: -5000), velocity: (0.0, 200.0), image: UIImage(named: leve11EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 5*width/6, y: -5000), velocity: (0.0, 200.0), image: UIImage(named: leve11EnemyImageName)!, radius: 30))
    }
    
    func setupLevel2() {
        (width, height) = delegate!.getGameFrame()
        
        let health = player.health
        
        player = Player(position: CGPoint(x: width/2, y: height - 50), velocity: (0.0, 0.0), image: UIImage(named: level2PlayerImageName)!, radius: 20)
        player.health = health
        enemies = []
        balls = []
        time = 0
        
        // Add Enemies
        
        // Diamond
        enemies.append(Enemy(position: CGPoint(x: width/2, y: -400), velocity: (0.0, 100.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 4*width/10, y: -450), velocity: (0.0, 100.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 6*width/10, y: -450), velocity: (0.0, 100.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 3*width/10, y: -500), velocity: (0.0, 100.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 7*width/10, y: -500), velocity: (0.0, 100.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 2*width/10, y: -550), velocity: (0.0, 100.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 8*width/10, y: -550), velocity: (0.0, 100.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 1*width/10, y: -600), velocity: (0.0, 100.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 9*width/10, y: -600), velocity: (0.0, 100.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 5*width/10, y: -600), velocity: (0.0, 100.0), image: UIImage(named: leve12EnemyImageName)!, radius: 50))
        enemies.append(Enemy(position: CGPoint(x: 2*width/10, y: -650), velocity: (0.0, 100.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 8*width/10, y: -650), velocity: (0.0, 100.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 3*width/10, y: -700), velocity: (0.0, 100.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 7*width/10, y: -700), velocity: (0.0, 100.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 4*width/10, y: -750), velocity: (0.0, 100.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 6*width/10, y: -750), velocity: (0.0, 100.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: width/2, y: -800), velocity: (0.0, 100.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        
        
        enemies.append(Enemy(position: CGPoint(x: 1*width/10, y: -2200), velocity: (0.0, 200.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 2*width/10, y: -2300), velocity: (0.0, 200.0), image: UIImage(named: leve12EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 3*width/10, y: -2400), velocity: (0.0, 200.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 4*width/10, y: -2500), velocity: (0.0, 200.0), image: UIImage(named: leve12EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 5*width/10, y: -2600), velocity: (0.0, 200.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 6*width/10, y: -2700), velocity: (0.0, 200.0), image: UIImage(named: leve12EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 7*width/10, y: -2800), velocity: (0.0, 200.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 8*width/10, y: -2900), velocity: (0.0, 200.0), image: UIImage(named: leve12EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 9*width/10, y: -3000), velocity: (0.0, 200.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 8*width/10, y: -3100), velocity: (0.0, 200.0), image: UIImage(named: leve12EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 7*width/10, y: -3200), velocity: (0.0, 200.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 6*width/10, y: -3300), velocity: (0.0, 200.0), image: UIImage(named: leve12EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 5*width/10, y: -3400), velocity: (0.0, 200.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 4*width/10, y: -3500), velocity: (0.0, 200.0), image: UIImage(named: leve12EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 3*width/10, y: -3600), velocity: (0.0, 200.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: 2*width/10, y: -3700), velocity: (0.0, 200.0), image: UIImage(named: leve12EnemyImageName)!, radius: 40))
        enemies.append(Enemy(position: CGPoint(x: 1*width/10, y: -3800), velocity: (0.0, 200.0), image: UIImage(named: leve12EnemyImageName)!, radius: 30))
        enemies.append(Enemy(position: CGPoint(x: width/2, y: -5500), velocity: (0.0, 250.0), image: UIImage(named: leve12EnemyImageName)!, radius: 100))
    }
    
    
}
