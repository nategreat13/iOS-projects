//
//  ViewController.swift
//  SportShooter
//
//  Created by Nate Gygi on 4/25/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var loginButton: UIButton!
    @IBOutlet var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        loginButton.layer.cornerRadius = loginButton.frame.height/2
        registerButton.layer.cornerRadius = registerButton.frame.height/2
        
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toRegister", sender: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.dismiss(animated: false, completion: nil)
    }


}

