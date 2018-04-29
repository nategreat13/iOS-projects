//
//  RegisterViewController.swift
//  SportShooter
//
//  Created by Nate Gygi on 4/25/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    @IBOutlet var backButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerButton.layer.cornerRadius = registerButton.frame.height/2
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        let email = emailTextfield.text!
        let password = passwordTextfield.text!
        let username = usernameTextfield.text!
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
            } else {
                self.performSegue(withIdentifier: "toMain", sender: nil)
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toHome", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toHome" {
            self.dismiss(animated: false, completion: nil)
        }
    }

}
