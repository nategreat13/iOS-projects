//
//  HighScores.swift
//  SportSportShooter
//
//  Created by Nate Gygi on 5/1/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import Foundation

// Class to represent the set of high scores
class HighScores {
    
    // A dictionary of 10 high scores, containing the date, username, and score for each one
    var highScores: [Int: (date: Date, username: String, score: Int)]
    
    // Default init
    init() {
        // Set everything to default values
        highScores = [:]
        for i in 0...9 {
            highScores[i] = (date: Date(), username: "", score: 0)
        }
    }
    
    // Initializer that uses a snapshot from Firebase database
    init(snapshot: NSDictionary) {
        highScores = [:]
        var username: String = ""
        var date: Date = Date()
        var score: Int = 0
        var place: Int = 0
        
        // For each high score in the snapshot
        for highScore in snapshot {
            // Get the key
            let highScoreKey = highScore.key as? String ?? ""
            // Make sure its a high score and not the count property
            if (highScoreKey != "Count") {
                // Get the place
                place = Int(highScoreKey)!
                let value = highScore.value as? [String: Any] ?? [:]
                for pair in value {
                    switch pair.key {
                    // Get the date
                    case "Date":
                        let dateInterval = pair.value as? TimeInterval ?? 0
                        date = Date(timeIntervalSince1970: dateInterval)
                    // Get the score
                    case "Score":
                        score = pair.value as? Int ?? 0
                    // Get the username
                    case "Username":
                        username = pair.value as? String ?? ""
                    default:
                        break
                    }
                }
                // Set the high score for that place with the values
                highScores[place] = (date: date, username: username, score: score)
            }
        }
    }
    
    // Check if a score belongs in the top 10 high scores
    func isHighScore(score: Int) -> Bool {
        return score > highScores[9]!.score
    }
    
    // Add the score to the high scores
    func addHighScore(date: Date, username: String, score: Int) {
        // Make sure it belongs in the top 10
        if score <= highScores[9]!.score {
            return
        }
        // Find where it belongs
        var i = 10
        while (score > highScores[i-1]!.score) {
            i -= 1
            if i == 1 {
                break
            }
        }
        var j = 10
        // Shift everything down one until the place where it belongs
        while (j > i) {
            highScores[j]! = highScores[j-1]!
            j -= 1
        }
        // Add it to the place it belongs
        highScores[j] = (date, username, score)
        // Update the database
        sendToDatabase()
    }
    
    // Saves the high scores to the database
    func sendToDatabase() {
        for i in 1...10 {
            DB.database.child("HighScores/\(i)").updateChildValues(["Date": highScores[i]!.date.timeIntervalSince1970, "Score": highScores[i]!.score, "Username": highScores[i]!.username])
        }
    }
}
