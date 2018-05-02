//
//  GameViewController.swift
//  SportShooter
//
//  Created by Nate Gygi on 4/28/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit


/*
    Controller for a gameView. Contains a top information bar, a gameView, and a control view.
 */
class GameViewController: UIViewController, GameDelegate {

    // Back Button
    @IBOutlet var backButton: UIButton!
    
    // Labels for the level, score, and health
    @IBOutlet var levelLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var healthLabel: UILabel!
    
    // The gameView that represents a game. Used to display all subviews
    @IBOutlet var gameView: GameView!
    
    // Control buttons, for shoot, up, down, left, right
    @IBOutlet var shootButton: UIButton!
    @IBOutlet var upButton: UIButton!
    @IBOutlet var leftButton: UIButton!
    @IBOutlet var downButton: UIButton!
    @IBOutlet var rightButton: UIButton!
    
    // Represents whether the player is currently firing
    var isFiring: Bool = false
    
    // A timer called frequently to update the state of the game
    var gameLoopTimer: Timer = Timer()
    // A timer called frequently to update the view
    var displayLoopTimer: Timer = Timer()
    
    // The model representating the state of the game
    var game: Game = Game()
    
    // Image names for the background images of the levels
    var gameBackgroundImageNames: [String] = ["SoccerField", "FootballField", "BasketballCourt"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DB.currentGameViewController = self
        
        // Make sure that the gameView and its background image have the correct frame
        gameView.frame = CGRect(x: view.bounds.minX, y: view.bounds.minY + 100, width: view.bounds.width, height: view.bounds.height - 250)
        gameView.backgroundImageView.frame = gameView.bounds
        
        // Set the background image
        gameView.backgroundImageView.image = UIImage(named: gameBackgroundImageNames[game.level-1])
        
        // Volunteer as delegate for the game
        game.delegate = self
        
        // If the game is a new game, then start, otherwise, resume a current game
        if game.isNew {
            start()
        }
        else {
            resume()
        }
    }
    
    // Resume a previous game
    func resume() {
        
        // Remove all subvies from the game except the background
        for subview in gameView.subviews {
            if subview != gameView.backgroundImageView {
                subview.removeFromSuperview()
            }
        }
        
        // Save the width and height of the gameView in the game
        game.width = view.bounds.width
        game.height = view.bounds.height
        
        // Add the player subview
        gameView.addCharacter(character: game.player)
        
        // Add each enemy subview
        for enemy in game.enemies {
            gameView.addCharacter(character: enemy)
        }
        
        // Add each ball subview
        for ball in game.balls {
            gameView.addCharacter(character: ball)
        }
        // Set the last execution to now, this is used in the gameLoop to determine how much time has passed since the last execution
        game.lastExecution = Date()
        
        // Fire off the displayLoppTimer and gameLoopTimer
        displayLoopTimer = Timer.scheduledTimer(timeInterval: 1/30, target: self, selector: #selector(displayLoop), userInfo: nil, repeats: true)
        gameLoopTimer = Timer.scheduledTimer(timeInterval: 1/30, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
    }
    
    // Start a new game
    func start() {
        
        // Setup for level 1
        game.setupLevel1()
        
        // Add the player subview
        gameView.addCharacter(character: game.player)
        
        // Add each enemy subview
        for enemy in game.enemies {
            gameView.addCharacter(character: enemy)
        }
        
        // Add each ball subview
        for ball in game.balls {
            gameView.addCharacter(character: ball)
        }
        
        // Set the last execution to now, this is used in the gameLoop to determine how much time has passed since the last execution
        game.lastExecution = Date()
        
        // Fire off the displayLoppTimer and gameLoopTimer
        displayLoopTimer = Timer.scheduledTimer(timeInterval: 1/30, target: self, selector: #selector(displayLoop), userInfo: nil, repeats: true)
        gameLoopTimer = Timer.scheduledTimer(timeInterval: 1/30, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
        
    }
    
    // Display loop used to update the display frequently with the state of the game
    @objc func displayLoop() {
        
        // Update the frame for the player
        gameView.updateCharacterFrame(character: game.player)
        
        // Update the frame for each enemy
        for enemy in game.enemies {
            gameView.updateCharacterFrame(character: enemy)
        }
        
        // Update the frame for each ball
        for ball in game.balls {
            gameView.updateCharacterFrame(character: ball)
        }
        
        // Update the score label
        scoreLabel.text = "Score \(game.score)"
    }
    
    // Game loop used to frequently update the state of the game
    @objc func gameLoop() {
        // Call the game loop of the game
        game.gameLoop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Called when the shoot button is pressed down
    @IBAction func shootButtonDown(_ sender: UIButton) {
        // Set isFiring to true
        isFiring = true
        
        // Add a ball that is shot
        self.game.addBall()
        
        // Set a timer to shoot a ball every half of a second as long as the button is maintained pressed down
        let timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer) in
            if self.isFiring {
                self.game.addBall()
            }
            else {
                timer.invalidate()
            }
        })
    }
    
    // Called when the shoot button is released
    @IBAction func shootButtonUp(_ sender: UIButton) {
        // No longer firing
        isFiring = false
        // Disable the shoot button for a brief period
        shootButton.isEnabled = false
        // Set a timer to enable the shoot button after a brief period
        let timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { (timer) in
            self.shootButton.isEnabled = true
        })
    }
    
    // Called when the up button is pressed down
    @IBAction func upButtonDown(_ sender: UIButton) {
        // Set the player's velocity to move up
        game.player.velocity = (0.0, -100.0)
        // Change the players image to be running
        game.changeImageToRunning()
    }
    
    // Called when the up button is released
    @IBAction func upButtonUp(_ sender: UIButton) {
        // Set the player's velocity to not move
        game.player.velocity = (0.0, 0.0)
        // Change the players image to be standing
        game.changeImageToStanding()
    }
    
    // Called when the left button is pressed down
    @IBAction func leftButtonDown(_ sender: UIButton) {
        // Set the player's velocity to move left
        game.player.velocity = (-100.0, 0.0)
        // Change the players image to be running
        game.changeImageToRunning()
    }
    
    // Called when the left button is released
    @IBAction func leftButtonUp(_ sender: UIButton) {
        // Set the player's velocity to not move
        game.player.velocity = (0.0, 0.0)
        // Change the players image to be standing
        game.changeImageToStanding()
    }
    
    // Called when the down button is pressed down
    @IBAction func downButtonDown(_ sender: UIButton) {
        // Set the player's velocity to move down
        game.player.velocity = (0.0, 100.0)
        // Change the players image to be running
        game.changeImageToRunning()
    }
    
     // Called when the down button is released
    @IBAction func downButtonUp(_ sender: UIButton) {
        // Set the player's velocity to not move
        game.player.velocity = (0.0, 0.0)
        // Change the players image to be standing
        game.changeImageToStanding()
    }
    
    // Called when the right button is pressed down
    @IBAction func rightButtonDown(_ sender: UIButton) {
        // Set the player's velocity to move right
        game.player.velocity = (100.0, 0.0)
        // Change the players image to be running
        game.changeImageToRunning()
    }
    
     // Called when the right button is released
    @IBAction func rightButtonUp(_ sender: UIButton) {
        // Set the player's velocity to not move
        game.player.velocity = (0.0, 0.0)
        // Change the players image to be standing
        game.changeImageToStanding()
    }
    
    ////////// GameDelegate //////////////
    // Add a ball this is shot
    func addBall(ball: Ball) {
        gameView.addCharacter(character: ball)
    }
    
    // Get the width and height of the gameView
    func getGameFrame() -> (width: CGFloat, height: CGFloat) {
        return (gameView.frame.width, gameView.frame.height)
    }
    
    // Called when the player's health has changed
    func healthChanged() {
        // Update the health label
        healthLabel.text = "Health: \(game.player.health)"
    }
    
    // Called to remove a subView from the gameView
    func removeImageView(imageView: UIImageView) {
        gameView.removeImageView(imageView: imageView)
    }
    
    // Called when a level is completed
    func levelFinished() {
        
        // Stop the timers
        displayLoopTimer.invalidate()
        gameLoopTimer.invalidate()
        
        // Remove all the subviews except the backgroundImageView
        for subview in gameView.subviews {
            if subview != gameView.backgroundImageView {
                subview.removeFromSuperview()
            }
        }
        // Increment the level
        game.level += 1
        // If moved on to level 2
        if game.level == 2 {
            // Update the level text
            levelLabel.text = "Level: 2"
            // Setup level 2
            game.setupLevel2()
            
            // Set the background for level2
            gameView.backgroundImageView.image = UIImage(named: "FootballField")
            
            // Add the player image view
            gameView.addCharacter(character: game.player)
            
            // Add each enemy image view
            for enemy in game.enemies {
                gameView.addCharacter(character: enemy)
            }
            
            // Add each ball image view
            for ball in game.balls {
                gameView.addCharacter(character: ball)
            }
            
            
            // Set the last execution to now, this is used in the gameLoop to determine how much time has passed since the last execution
            game.lastExecution = Date()
            
            // Fire off the displayLoppTimer and gameLoopTimer
            displayLoopTimer = Timer.scheduledTimer(timeInterval: 1/30, target: self, selector: #selector(displayLoop), userInfo: nil, repeats: true)
            gameLoopTimer = Timer.scheduledTimer(timeInterval: 1/30, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
        }
        // If advanced to level 3
        else if game.level == 3 {
            // Update the level label
            levelLabel.text = "Level: 3"
            
            // Setup Level 3
            game.setupLevel3()
            
            // Change the background image for level 3
            gameView.backgroundImageView.image = UIImage(named: "BasketballCourt")
            
            // Add the player image view
            gameView.addCharacter(character: game.player)
            
            // Add each enemy image view
            for enemy in game.enemies {
                gameView.addCharacter(character: enemy)
            }
            
            // Add each ball image view
            for ball in game.balls {
                gameView.addCharacter(character: ball)
            }
            
            // Set the last execution to now, this is used in the gameLoop to determine how much time has passed since the last execution
            game.lastExecution = Date()
            
            // Fire off the displayLoppTimer and gameLoopTimer
            displayLoopTimer = Timer.scheduledTimer(timeInterval: 1/30, target: self, selector: #selector(displayLoop), userInfo: nil, repeats: true)
            gameLoopTimer = Timer.scheduledTimer(timeInterval: 1/30, target: self, selector: #selector(gameLoop), userInfo: nil, repeats: true)
            
        }
        // If all 3 levels have been completed
        else {
            // If the score is a high score
            if DB.highScores.isHighScore(score: self.game.score) {
                
                // Add the high score
                DB.highScores.addHighScore(date: Date(), username: DB.currentUsername, score: self.game.score)
                
                // Bring up an alert to let the user know they won and that they have a high score
                let alert = UIAlertController(title: "Congrats! You completed the game.", message: "You got a new high score!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "See High Scores", style: .default, handler: { action in
                    self.performSegue(withIdentifier: "toHighScores", sender: nil)
                }))
                self.present(alert, animated: true)
            }
            // If the score is not a high score
            else {
                // Bring up an alert to let the user know they won
                let alert = UIAlertController(title: "Congrats! You completed the game.", message: "Your score is \(game.score)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    self.performSegue(withIdentifier: "toMain", sender: nil)
                }))
                self.present(alert, animated: true)
            }
            // Set the users game to be blank
            DB.database.child("Users/\(DB.currentEmail.replacingOccurrences(of: ".", with: ""))")
                .updateChildValues(["Game": " "])
            // Set the savedGame to be a default game but set it to be invalid so it cant be resumed
            DB.savedGame = Game()
            DB.savedGame.isValid = false
        }
    }
    
    // Called when a player loses all his health
    func gameOver() {
        
        // Stop the timers
        gameLoopTimer.invalidate()
        displayLoopTimer.invalidate()
        
        // Set the users game to be blank
        DB.database.child("Users/\(DB.currentEmail.replacingOccurrences(of: ".", with: ""))")
            .updateChildValues(["Game": " "])
        // Set the savedGame to be a default game but set it to be invalid so it cant be resumed
        DB.savedGame = Game()
        DB.savedGame.isValid = false
        
        // Remove all the subviews in the gameView except the background imageView
        for subview in gameView.subviews {
            if subview != gameView.backgroundImageView {
                subview.removeFromSuperview()
            }
        }
        
        // If the score is a high score
        if DB.highScores.isHighScore(score: self.game.score) {
            
            // Add the score to high scores
            DB.highScores.addHighScore(date: Date(), username: DB.currentUsername, score: self.game.score)
            
            // Bring up an alert to let the user know the have a game over and that they have a high score
            let alert = UIAlertController(title: "Congrats! You got a high score.", message: "Your score is \(game.score)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "See High Scores", style: .default, handler: { action in
                self.performSegue(withIdentifier: "toHighScores", sender: nil)
            }))
            self.present(alert, animated: true)
        }
        // If the score is not a high score
        else {
            // Bring up an alert to let the user know the have a game over
            let alert = UIAlertController(title: "Game Over", message: "Your score is \(game.score)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                self.performSegue(withIdentifier: "toMain", sender: nil)
            }))
            self.present(alert, animated: true)
        }
        
    }
    //////////////////////////////////////
    
    // Prepare for segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMain" {
            // Stop the timers
            displayLoopTimer.invalidate()
            gameLoopTimer.invalidate()
            // If the players is dead
            if game.player.health <= 0 {
                // Set the savedGame to be a default game but set it to be invalid so it cant be resumed
                DB.database.child("Users/\(DB.currentEmail.replacingOccurrences(of: ".", with: ""))")
                    .updateChildValues(["Game": " "])
                DB.savedGame = Game()
                DB.savedGame.isValid = false
            }
            else {
                // Save the game to the database
                game.saveToDatabaseFor(email: DB.currentEmail)
            }
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func pauseGame() {
        // Stop the timers
        displayLoopTimer.invalidate()
        gameLoopTimer.invalidate()
        // Save the game to the database
        game.saveToDatabaseFor(email: DB.currentEmail)
    }
    
    
}
