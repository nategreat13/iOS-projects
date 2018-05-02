//
//  HighScoreTableViewCell.swift
//  SportShooter
//
//  Created by Nate Gygi on 4/26/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class HighScoreTableViewCell: UITableViewCell {

    // Labels for the custom cell
    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Used to create a cell for a high score
    func commonInit(place: Int, score: Int, username: String, date: Date) {
        placeLabel.text = String(place)
        scoreLabel.text = String(score)
        usernameLabel.text = username
        dateLabel.text = getStringFromDate(date: date)
    }
    
    // Used to create a header cell
    func headerInit() {
        placeLabel.textAlignment = .center
        placeLabel.text = ""
        scoreLabel.text = "Score"
        usernameLabel.text = "Username"
        dateLabel.text = "Date"
    }
    
    // Convert a Date to a string to be displayed
    func getStringFromDate(date: Date) -> String {
        let calendar = Calendar.current
        return "\(calendar.component(.month, from: date))-\(calendar.component(.day, from: date))-\(calendar.component(.year, from: date))"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
