//
//  LoginViewController.swift
//  SportShooter
//
//  Created by Nate Gygi on 4/26/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit
import Firebase

// Controllor for the LoginView
class LoginViewController: UIViewController, UITextFieldDelegate {

    // Password and Email text fields
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    
    // Login button
    @IBOutlet var loginButton: UIButton!
    
    // Back button
    @IBOutlet var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Volunteer as delegate for the textfields
        passwordTextfield.delegate = self
        emailTextfield.delegate = self

        // Round the corners of the login button
        loginButton.layer.cornerRadius = loginButton.frame.height/2
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Called when the login button is pressed
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        // Get the email
        let email = emailTextfield.text!
        // Get the password
        let password = passwordTextfield.text!
        // Try to sign in
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            // If there was an error, let the user know
            if (error != nil) {
                let alert = UIAlertController(title: "Invalid Credentials", message: "Please Try Again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                }))
                self.present(alert, animated: true)
            }
            // If successful
            else {
                // Get the username and set it in DB
                DB.database.child("Users").child(email.replacingOccurrences(of: ".", with: "")).child("Username").observeSingleEvent(of: .value, with: { (snapshot) in
                    DB.currentUsername = snapshot.value as? String ?? ""
                })
                // Set the current email in DB
                DB.currentEmail = email.replacingOccurrences(of: ".", with: "")
                // Load the saved game for this user
                DB.loadSavedGameFor(email: email)
                self.performSegue(withIdentifier: "toMain", sender: self)
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
    
    // Prepare for segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHome" {
            
            self.dismiss(animated: false, completion: nil)
        }
    }
}
