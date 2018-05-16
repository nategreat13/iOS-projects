//
//  RegisterViewController.swift
//  SportShooter
//
//  Created by Nate Gygi on 4/25/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {

    // Textfields
    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    // Buttons
    @IBOutlet var backButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Volunteer as delegate for textfields
        passwordTextfield.delegate = self
        emailTextfield.delegate = self
        usernameTextfield.delegate = self
        
        registerButton.layer.cornerRadius = registerButton.frame.height/2
        // Do any additional setup after loading the view.
    }
    
    // Called when the register button is pressed
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        // Get the email
        let email = emailTextfield.text!
        // Get the password
        let password = passwordTextfield.text!
        // Get the username
        let username = usernameTextfield.text!
        // Try to register
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            // If it didnt work, let the user know
            if error != nil {
                print(error!.localizedDescription)
                print(error.debugDescription)
                let alert = UIAlertController(title: "Something went wrong", message: "Make sure your password has at least 8 characters, 1 numeral, and 1 capital letter.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                }))
                self.present(alert, animated: true)
            }
            // If successful
            else {
                // Add the user to the database
                DB.database.child("Users/\(email.replacingOccurrences(of: ".", with: ""))").updateChildValues(["Username": username])
                DB.database.child("Users/\(email.replacingOccurrences(of: ".", with: ""))").updateChildValues(["Game": " "])
                // Set the current username in DB
                DB.currentUsername = username
                // Set the current email in DB
                DB.currentEmail = email.replacingOccurrences(of: ".", with: "")
                // Make sure the savedGame isnt valid because the player hasnt played a game yet
                DB.savedGame.isValid = false
                self.performSegue(withIdentifier: "toMain", sender: nil)
            }
        }
    }
    
    // Method to allow the keyboard to dismiss when the return key is clicked
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // Called when the back button is pressed
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toHome", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Prepare for segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHome" {
            self.dismiss(animated: false, completion: nil)
        }
    }

}
