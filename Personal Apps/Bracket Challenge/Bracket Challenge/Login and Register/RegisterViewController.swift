//
//  RegisterViewController.swift
//  Bracket Challenge
//
//  Created by Nate Gygi on 5/16/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    @IBOutlet var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerButton.layer.cornerRadius = registerButton.frame.height/2
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        let email = emailTextfield.text!
        let username = usernameTextfield.text!
        let password = passwordTextfield.text!
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            // If it didnt work, let the user know
            if error != nil {
                let alert = UIAlertController(title: "Something went wrong", message: "Make sure your password has at least 8 characters, 1 numeral, and 1 capital letter.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                }))
                self.present(alert, animated: true)
            }
            // If successful
            else {
                // Add the user to the database
                DB.database.child("Users/\(username))").updateChildValues(["email": email])
                // Set the current username in DB
                DB.currentUsername = username
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
