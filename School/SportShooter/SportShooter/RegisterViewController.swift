//
//  RegisterViewController.swift
//  SportShooter
//
//  Created by Nate Gygi on 4/25/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet var usernameTextfield: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    @IBOutlet var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextfield.layer.cornerRadius = usernameTextfield.frame.height/2
        emailTextfield.layer.cornerRadius = emailTextfield.frame.height/2
        passwordTextfield.layer.cornerRadius = passwordTextfield.frame.height/2
        registerButton.layer.cornerRadius = registerButton.frame.height/2
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
