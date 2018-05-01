//
//  MainViewController.swift
//  SportShooter
//
//  Created by Nate Gygi on 4/26/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewGame" {
            let vc = segue.destination as! GameViewController
            vc.game = Game()
        }
    }
    
    
    
    
}
