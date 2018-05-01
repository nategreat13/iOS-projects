//
//  GameView.swift
//  SportSportShooter
//
//  Created by Nate Gygi on 4/28/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class GameView: UIView {
    
    var backgroundImageView: UIImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView.frame = self.bounds
        addSubview(backgroundImageView)
    }
    
    func addCharacter(character: Character) {
        character.image.frame = CGRect(x: bounds.minX + (character.position.x - character.radius), y: bounds.minY + (character.position.y - character.radius), width: 2*character.radius, height: 2*character.radius)
        addSubview(character.image)
    }
    
    func updateCharacterFrame(character: Character) {
        character.image.frame = CGRect(x: bounds.minX + (character.position.x - character.radius), y: bounds.minY + (character.position.y - character.radius), width: 2*character.radius, height: 2*character.radius)
    }
    
    func removeImageView(imageView: UIImageView) {
        imageView.removeFromSuperview()
    }
    
    func gameOver(score: Int) {
        let gameOverLabel = UILabel()
        gameOverLabel.text = "Game Over! Your Score is \(score)"
        addSubview(gameOverLabel)
        gameOverLabel.textAlignment = .center
        gameOverLabel.lineBreakMode = .byWordWrapping
        gameOverLabel.numberOfLines = 0
        gameOverLabel.font = UIFont(name: "Helvetica", size: 36)
        gameOverLabel.frame = CGRect(x: bounds.midX - 100, y: bounds.midY - 125, width: 200, height: 250)
    }

}
