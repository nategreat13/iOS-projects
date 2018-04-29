//
//  HighScoreTableViewCell.swift
//  SportShooter
//
//  Created by Nate Gygi on 4/26/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class HighScoreTableViewCell: UITableViewCell {

    @IBOutlet var placeLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func commonInit(place: Int, score: Int, username: String) {
        placeLabel.text = String(place)
        scoreLabel.text = String(score)
        usernameLabel.text = username
    }
    
    func headerInit() {
        placeLabel.text = "Place"
        scoreLabel.text = "Score"
        usernameLabel.text = "Username"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
