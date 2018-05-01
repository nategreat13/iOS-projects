//
//  HighScoresViewController.swift
//  SportShooter
//
//  Created by Nate Gygi on 4/26/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class HighScoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var backButton: UIButton!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        print(tableView.frame.debugDescription)
        tableView.backgroundColor = UIColor.white
        
        let nib = UINib.init(nibName: "HighScoreTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HighScoreTableViewCell")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HighScoreTableViewCell", for: indexPath) as? HighScoreTableViewCell {
                cell.headerInit()
                return cell
            }
        }
         */
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HighScoreTableViewCell", for: indexPath) as? HighScoreTableViewCell {
            cell.commonInit(place: indexPath.row + 1, score: 100, username: "nategreat13")
            return cell
        }
        return UITableViewCell()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMain" {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
}
