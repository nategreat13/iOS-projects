//
//  GameView.swift
//  SportSportShooter
//
//  Created by Nate Gygi on 4/28/18.
//  Copyright © 2018 Nate Gygi. All rights reserved.
//

import UIKit

class GameView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.red
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // get the context and clear the bounds
        guard let context: CGContext = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(2.0)
        
        context.move(to: CGPoint(x: bounds.minX + 10, y: bounds.minY + 10))
        context.addLine(to: CGPoint(x: bounds.maxX - 10, y: bounds.minY + 10))
        
        context.move(to: CGPoint(x: bounds.minX + 10, y: bounds.minY + 10))
        context.addLine(to: CGPoint(x: bounds.minX + 10, y: bounds.maxY - 10))
        
        context.move(to: CGPoint(x: bounds.maxX - 10, y: bounds.minY + 10))
        context.addLine(to: CGPoint(x: bounds.maxX - 10, y: bounds.maxY - 10))
        
        context.move(to: CGPoint(x: bounds.minX + 10, y: bounds.maxY - 10))
        context.addLine(to: CGPoint(x: bounds.maxX - 10, y: bounds.maxY - 10))
        
        context.drawPath(using: .fillStroke)
    }

}
