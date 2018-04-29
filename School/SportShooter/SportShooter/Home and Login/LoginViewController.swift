//
//  LoginViewController.swift
//  SportShooter
//
//  Created by Nate Gygi on 4/26/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = loginButton.frame.height/2
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let email = emailTextfield.text!
        let password = passwordTextfield.text!
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if (error != nil) {
                print(error!)
            }
            else {
                self.performSegue(withIdentifier: "toMain", sender: self)
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toHome", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHome" {
            self.dismiss(animated: false, completion: nil)
        }
    }
}
