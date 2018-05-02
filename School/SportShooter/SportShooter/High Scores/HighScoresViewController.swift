//
//  HighScoresViewController.swift
//  SportShooter
//
//  Created by Nate Gygi on 4/26/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

// View controller for the High Scores View
class HighScoresViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Back button
    @IBOutlet var backButton: UIButton!
    
    // Table view displaying the high scores
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Colunterr as delegate and data source for the table view
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set the background color of the table view
        tableView.backgroundColor = UIColor.white
        
        // Register the table view
        let nib = UINib.init(nibName: "HighScoreTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "HighScoreTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Returns the height for a given row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height/11
    }
    
    // Returns the number of rows in a section (just one section with 11 rows in this case)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    // Return the cell at a given row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // If its the top row, creat a header cell
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HighScoreTableViewCell", for: indexPath) as? HighScoreTableViewCell {
                // Create a header cell
                cell.headerInit()
                return cell
            }
        }
        // Otherwise
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HighScoreTableViewCell", for: indexPath) as? HighScoreTableViewCell {
            // Get the row
            let row = indexPath.row
            // Get the values for the high score represented by that row
            let score = DB.highScores.highScores[row]!.score
            let username = DB.highScores.highScores[row]!.username
            let date = DB.highScores.highScores[row]!.date
            // Create the cell
            cell.commonInit(place: row, score: score, username: username, date: date)
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
