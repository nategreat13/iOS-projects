//
//  GameView.swift
//  SportSportShooter
//
//  Created by Nate Gygi on 4/28/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class GameView: UIView {
    
    // View for the background image
    var backgroundImageView: UIImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Set the backgroundImageView frame
        backgroundImageView.frame = self.bounds
        
        // Add the backgroundImageView to the gameView
        addSubview(backgroundImageView)
    }
    
    // Add a character subview
    func addCharacter(character: Character) {
        // Set the character's frame based on the position of the character
        character.image.frame = CGRect(x: bounds.minX + (character.position.x - character.radius), y: bounds.minY + (character.position.y - character.radius), width: 2*character.radius, height: 2*character.radius)
        // Add the chracter image as a subview
        addSubview(character.image)
    }
    
    // Update the character subviews
    func updateCharacterFrame(character: Character) {
        // Update the character's frame based on the position of the character
        character.image.frame = CGRect(x: bounds.minX + (character.position.x - character.radius), y: bounds.minY + (character.position.y - character.radius), width: 2*character.radius, height: 2*character.radius)
    }
    
    // Remove the given imageView from the gameView
    func removeImageView(imageView: UIImageView) {
        imageView.removeFromSuperview()
    }

}
