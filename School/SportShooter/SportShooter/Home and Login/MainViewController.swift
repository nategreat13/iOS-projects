//
//  MainViewController.swift
//  SportShooter
//
//  Created by Nate Gygi on 4/26/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit
import Firebase

// Controller for the MainView
class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Prepare for segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If going to a new game
        if segue.identifier == "toNewGame" {
            let vc = segue.destination as! GameViewController
            // Set the destination view controller's game to be a new game
            vc.game = Game()
        }
        // If resuming a game
        if segue.identifier == "toResumeGame" {
            let vc = segue.destination as! GameViewController
            // Set the destination view controller's game to be the saved game
            vc.game = DB.savedGame
            // Set the games isNew property to false because it is not a new game
            vc.game.isNew = false
        }
        // If going to home because of logout
        if segue.identifier == "toHome" {
            // Reset everything in DB
            DB.currentEmail = ""
            DB.currentUsername = ""
            DB.savedGame = Game()
            DB.savedGame.isValid = false
            do
            {
                //Try to sign out
                try Auth.auth().signOut()
            }
            catch let signOutError as NSError{
                print("Error signing out: %@", signOutError)
            }
        }
    }
    
    // Called when the resume game button is pressed
    @IBAction func resumeButtonPressed(_ sender: UIButton) {
        // If the savedGame is a valid game, open a gameViewController
        if DB.savedGame.isValid {
            performSegue(withIdentifier: "toResumeGame", sender: nil)
        }
        // If the savedGame is not a valid game
        else {
            // Tell the user they dont have a game to resume
            let alert = UIAlertController(title: "You do not have a game to resume", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
            self.present(alert, animated: true)
        }
    }
    
    
}
