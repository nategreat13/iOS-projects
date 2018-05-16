//
//  ViewController.swift
//  Bracket Challenge
//
//  Created by Nate Gygi on 5/16/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = loginButton.frame.height/2
        registerButton.layer.cornerRadius = registerButton.frame.height/2
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

