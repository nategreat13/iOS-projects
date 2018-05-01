//
//  GameViewController.swift
//  SportShooter
//
//  Created by Nate Gygi on 4/28/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, GameDelegate {

    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var healthLabel: UILabel!
    
    @IBOutlet var gameView: GameView!
    
    @IBOutlet var shootButton: UIButton!
    @IBOutlet var upButton: UIButton!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var downButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    
    var isFiring: Bool = false
    
    var gameLoopTimer: Timer = Timer()
    var displayLoopTimer: Timer = Timer()
    
    var game: Game = Game()
    
    var gameBackgroundImageNames: [String] = ["SoccerField"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.delegate = self
        start()
    }
    
    func start() {
        gameView.backgroundImageView.image = UIImage(named: gameBackgroundImageNames[game.level-1])
        
        game.setupLevel1()
        
        gameView.addCharacter(character: game.player)
        for enemy in game.enemies {
            gameView.addCharacter(character: enemy)
        }
        for ball in game.balls {
            gameView.addCharacter(character: ball)
        }
        game.lastExecution = Date()
        
        displayLoopTimer = Timer.scheduledTimer(timeInterval: 1/30, target: self, selector: #selector(displayLoop), userInfo: nil, repeats: true)
        gameLoopTimer = Timer.scheduledTimer(timeInterval: 1/30, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
        
    }
    
    @objc func displayLoop() {
        gameView.updateCharacterFrame(character: game.player)
        for enemy in game.enemies {
            gameView.updateCharacterFrame(character: enemy)
        }
        for ball in game.balls {
            gameView.updateCharacterFrame(character: ball)
        }
        scoreLabel.text = "Score \(game.score)"
    }
    
    @objc func gameLoop() {
        game.gameLoop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shootButtonDown(_ sender: UIButton) {
        isFiring = true
        self.game.addBall()
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer) in
            if self.isFiring {
                self.game.addBall()
            }
            else {
                timer.invalidate()
            }
        })
    }
    
    @IBAction func shootButtonUp(_ sender: UIButton) {
        isFiring = false
    }
    
    @IBAction func upButtonDown(_ sender: UIButton) {
        game.player.velocity = (0.0, -100.0)
    }
    
    @IBAction func upButtonUp(_ sender: UIButton) {
        game.player.velocity = (0.0, 0.0)
    }
    
    @IBAction func leftButtonDown(_ sender: UIButton) {
        game.player.velocity = (-100.0, 0.0)
    }
    
    @IBAction func leftButtonUp(_ sender: UIButton) {
        game.player.velocity = (0.0, 0.0)
    }
    
    @IBAction func downButtonDown(_ sender: UIButton) {
        game.player.velocity = (0.0, 100.0)
    }
    
    @IBAction func downButtonUp(_ sender: UIButton) {
        game.player.velocity = (0.0, 0.0)
    }
    
    @IBAction func rightButtonDown(_ sender: UIButton) {
        game.player.velocity = (100.0, 0.0)
    }
    
    @IBAction func rightButtonUp(_ sender: UIButton) {
        game.player.velocity = (0.0, 0.0)
    }
    
    ////////// GameDelegate //////////////
    func addBall(ball: Ball) {
        gameView.addCharacter(character: ball)
    }
    
    func getGameFrame() -> (width: CGFloat, height: CGFloat) {
        return (gameView.frame.width, gameView.frame.height)
    }
    
    func healthChanged() {
        healthLabel.text = "Health: \(game.player.health)"
    }
    
    func removeImageView(imageView: UIImageView) {
        gameView.removeImageView(imageView: imageView)
    }
    
    func levelFinished() {
        displayLoopTimer.invalidate()
        gameLoopTimer.invalidate()
        for subview in gameView.subviews {
            if subview != gameView.backgroundImageView {
                subview.removeFromSuperview()
            }
        }
        game.level += 1
        if game.level == 2 {
            levelLabel.text = "Level: 2"
            game.setupLevel2()
            
            gameView.backgroundImageView.image = UIImage(named: "BasketballCourt")
            
            gameView.addCharacter(character: game.player)
            for enemy in game.enemies {
                gameView.addCharacter(character: enemy)
            }
            for ball in game.balls {
                gameView.addCharacter(character: ball)
            }
            
            game.lastExecution = Date()
            
            displayLoopTimer = Timer.scheduledTimer(timeInterval: 1/30, target: self, selector: #selector(displayLoop), userInfo: nil, repeats: true)
            gameLoopTimer = Timer.scheduledTimer(timeInterval: 1/30, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
        }
    }
    
    func gameOver() {
        gameLoopTimer.invalidate()
        displayLoopTimer.invalidate()
        for subview in gameView.subviews {
            if subview != gameView.backgroundImageView {
                subview.removeFromSuperview()
            }
        }
        gameView.gameOver(score: game.score)
    }
    //////////////////////////////////////
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMain" {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
}
