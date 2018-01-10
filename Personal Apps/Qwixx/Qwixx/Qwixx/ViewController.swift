//
//  ViewController.swift
//  Qwixx
//
//  Created by Nate Gygi on 11/3/17.
//  Copyright © 2017 Nate Gygi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Red Buttons
    @IBOutlet weak var red2: UIButton!
    @IBOutlet weak var red3: UIButton!
    @IBOutlet weak var red4: UIButton!
    @IBOutlet weak var red5: UIButton!
    @IBOutlet weak var red6: UIButton!
    @IBOutlet weak var red7: UIButton!
    @IBOutlet weak var red8: UIButton!
    @IBOutlet weak var red9: UIButton!
    @IBOutlet weak var red10: UIButton!
    @IBOutlet weak var red11: UIButton!
    @IBOutlet weak var red12: UIButton!
    @IBOutlet weak var red1: UIButton!
    
    // Yellow Buttons
    @IBOutlet weak var yellow1: UIButton!
    @IBOutlet weak var yellow2: UIButton!
    @IBOutlet weak var yellow3: UIButton!
    @IBOutlet weak var yellow4: UIButton!
    @IBOutlet weak var yellow5: UIButton!
    @IBOutlet weak var yellow6: UIButton!
    @IBOutlet weak var yellow7: UIButton!
    @IBOutlet weak var yellow8: UIButton!
    @IBOutlet weak var yellow9: UIButton!
    @IBOutlet weak var yellow10: UIButton!
    @IBOutlet weak var yellow11: UIButton!
    @IBOutlet weak var yellow12: UIButton!
    
    // Green Buttons
    @IBOutlet weak var green12: UIButton!
    @IBOutlet weak var green11: UIButton!
    @IBOutlet weak var green10: UIButton!
    @IBOutlet weak var green9: UIButton!
    @IBOutlet weak var green8: UIButton!
    @IBOutlet weak var green7: UIButton!
    @IBOutlet weak var green6: UIButton!
    @IBOutlet weak var green5: UIButton!
    @IBOutlet weak var green4: UIButton!
    @IBOutlet weak var green3: UIButton!
    @IBOutlet weak var green2: UIButton!
    @IBOutlet weak var green1: UIButton!
    
    // Blue Buttons
    @IBOutlet weak var blue12: UIButton!
    @IBOutlet weak var blue11: UIButton!
    @IBOutlet weak var blue10: UIButton!
    @IBOutlet weak var blue9: UIButton!
    @IBOutlet weak var blue8: UIButton!
    @IBOutlet weak var blue7: UIButton!
    @IBOutlet weak var blue6: UIButton!
    @IBOutlet weak var blue5: UIButton!
    @IBOutlet weak var blue4: UIButton!
    @IBOutlet weak var blue3: UIButton!
    @IBOutlet weak var blue2: UIButton!
    @IBOutlet weak var blue1: UIButton!
    
    @IBOutlet weak var miss1: UIButton!
    @IBOutlet weak var miss2: UIButton!
    @IBOutlet weak var miss3: UIButton!
    @IBOutlet weak var miss4: UIButton!
    
    // Keep track of the last button pressed for each color
    var redLastPressed: Int = 0
    var yellowLastPressed: Int = 0
    var greenLastPressed: Int = 0
    var blueLastPressed: Int = 0
    
    // Keep track of how many buttons of each color have been pressed
    var numRedPressed: Int = 0
    var numYellowPressed: Int = 0
    var numGreenPressed: Int = 0
    var numBluePressed: Int = 0
    
    // Keep track of misses
    var numMisses: Int = 0
    
    // Keep track of how many colors have been locked, game ends when 2 colors are locked
    var numLocked = 0
    
    // Array of colored buttons
    var redButtonArray: [UIButton] = []
    var yellowButtonArray: [UIButton] = []
    var greenButtonArray: [UIButton] = []
    var blueButtonArray: [UIButton] = []
    
    // Score labels
    @IBOutlet weak var redScoreLabel: UILabel!
    @IBOutlet weak var yellowScoreLabel: UILabel!
    @IBOutlet weak var greenScoreLabel: UILabel!
    @IBOutlet weak var blueScoreLabel: UILabel!
    @IBOutlet weak var missScoreLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    
    // Keep track of moves to be undone
    var undoStack: UndoStack = UndoStack()
    
    // Color variables
    let redColor: UIColor = UIColor(displayP3Red: CGFloat(255.0/255.0), green: CGFloat(141.0/255.0), blue: CGFloat(134.0/255.0), alpha: 1.0)
    let yellowColor: UIColor = UIColor(displayP3Red: CGFloat(255.0/255.0), green: CGFloat(254.0/255.0), blue: CGFloat(176.0/255.0), alpha: 1.0)
    let greenColor: UIColor = UIColor(displayP3Red: CGFloat(121.0/255.0), green: CGFloat(255.0/255.0), blue: CGFloat(127.0/255.0), alpha: 1.0)
    let blueColor: UIColor = UIColor(displayP3Red: CGFloat(172.0/255.0), green: CGFloat(182.0/255.0), blue: CGFloat(255.0/255.0), alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupButtonArrays()
        startNew()
        
    }
    
    // Start a new game, reset the scorecard
    func startNew() {
        redLastPressed = 0
        yellowLastPressed = 0
        greenLastPressed = 0
        blueLastPressed = 0
        
        numRedPressed = 0
        numYellowPressed = 0
        numGreenPressed = 0
        numBluePressed = 0
        
        numMisses = 0
        numLocked = 0
        
        redScoreLabel.text = "0"
        yellowScoreLabel.text = "0"
        greenScoreLabel.text = "0"
        blueScoreLabel.text = "0"
        missScoreLabel.text = "0"
        totalScoreLabel.text = "0"
        
        undoStack.clear()
        
        for button in redButtonArray {
            button.backgroundColor = redColor
        }
        for button in yellowButtonArray {
            button.backgroundColor = yellowColor
        }
        for button in greenButtonArray {
            button.backgroundColor = greenColor
        }
        for button in blueButtonArray {
            button.backgroundColor = blueColor
        }
        miss1.setTitleColor(UIColor.white, for: UIControlState.normal)
        miss2.setTitleColor(UIColor.white, for: UIControlState.normal)
        miss3.setTitleColor(UIColor.white, for: UIControlState.normal)
        miss4.setTitleColor(UIColor.white, for: UIControlState.normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Handle reset button
    @IBAction func resetPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Reset", message: "Are you sure you want to reset?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .`default`, handler: { _ in
            self.startNew()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .`default`, handler: { _ in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Handle red button pressed
    @IBAction func redButtonPressed(_ sender: UIButton) {
        // If the lock button is clicked and there are 5 reds pressed, lock the reds
        if (sender.tag == 1 && redLastPressed != 13 && numRedPressed >= 5) {
            redButtonArray[0].backgroundColor = UIColor.darkGray
            numRedPressed += 1
            numLocked += 1
            undoStack.push(color: 0, number: 1, prevLastPressed: redLastPressed)
            redLastPressed = 13
            if (numLocked == 2) {
                gameOver()
            }
        }
        // If the number pressed is still clickable
        if (sender.tag > redLastPressed) {
            redButtonArray[sender.tag - 1].backgroundColor = UIColor.darkGray
            numRedPressed += 1
            undoStack.push(color: 0, number: sender.tag, prevLastPressed: redLastPressed)
            redLastPressed = sender.tag
        }
        updateScore()
    }
    
    // Handle yello button pressed
    @IBAction func yellowButtonPressed(_ sender: UIButton) {
        // If the lock button is clicked and there are 5 yellows pressed, lock the yellow
        if (sender.tag == 1 && yellowLastPressed != 13 && numYellowPressed >= 5) {
            yellowButtonArray[0].backgroundColor = UIColor.darkGray
            numYellowPressed += 1
            numLocked += 1
            undoStack.push(color: 1, number: 1, prevLastPressed: yellowLastPressed)
            yellowLastPressed = 13
            if (numLocked == 2) {
                gameOver()
            }
        }
        // If the number pressed is still clickable
        if (sender.tag > yellowLastPressed) {
            yellowButtonArray[sender.tag - 1].backgroundColor = UIColor.darkGray
            undoStack.push(color: 1, number: sender.tag, prevLastPressed: yellowLastPressed)
            yellowLastPressed = sender.tag
            numYellowPressed += 1
        }
        updateScore()
    }
    
    // Handle green button pressed
    @IBAction func greenButtonPressed(_ sender: UIButton) {
        // If the lock button is clicked and there are 5 greens pressed, lock the green
        if (sender.tag == 1 && greenLastPressed != 13 && numGreenPressed >= 5) {
            greenButtonArray[0].backgroundColor = UIColor.darkGray
            numGreenPressed += 1
            numLocked += 1
            undoStack.push(color: 2, number: 1, prevLastPressed: greenLastPressed)
            greenLastPressed = 13
            if (numLocked == 2) {
                gameOver()
            }
        }
        // If the number pressed is still clickable
        if (sender.tag > greenLastPressed) {
            greenButtonArray[sender.tag - 1].backgroundColor = UIColor.darkGray
            undoStack.push(color: 2, number: sender.tag, prevLastPressed: greenLastPressed)
            greenLastPressed = sender.tag
            numGreenPressed += 1
        }
        updateScore()
    }
    
    // Handle blue button pressed
    @IBAction func blueButtonPressed(_ sender: UIButton) {
        // If the lock button is clicked and there are 5 blues pressed, lock the blue
        if (sender.tag == 1 && blueLastPressed != 13 && numBluePressed >= 5) {
            blueButtonArray[0].backgroundColor = UIColor.darkGray
            numBluePressed += 1
            numLocked += 1
            undoStack.push(color: 3, number: 1, prevLastPressed: blueLastPressed)
            blueLastPressed = 13
            if (numLocked == 2) {
                gameOver()
            }
        }
        // If the number pressed is still clickable
        if (sender.tag > blueLastPressed) {
            blueButtonArray[sender.tag - 1].backgroundColor = UIColor.darkGray
            undoStack.push(color: 3, number: sender.tag, prevLastPressed: blueLastPressed)
            blueLastPressed = sender.tag
            numBluePressed += 1
        }
        updateScore()
    }
    
    // Handle miss button pressed
    @IBAction func missButtonPressed(_ sender: UIButton) {
        switch(numMisses) {
        case 0:
            miss1.setTitleColor(UIColor.black, for: UIControlState.normal)
            numMisses += 1
            undoStack.push(color: 4, number: 0, prevLastPressed: 0)
        case 1:
            miss2.setTitleColor(UIColor.black, for: UIControlState.normal)
            numMisses += 1
            undoStack.push(color: 4, number: 1, prevLastPressed: 0)
        case 2:
            miss3.setTitleColor(UIColor.black, for: UIControlState.normal)
            numMisses += 1
            undoStack.push(color: 4, number: 2, prevLastPressed: 0)
        case 3:
            miss4.setTitleColor(UIColor.black, for: UIControlState.normal)
            numMisses += 1
            undoStack.push(color: 4, number: 3, prevLastPressed: 0)
            updateScore()
            gameOver()
        default:
            break
        }
        updateScore()
    }
    
    // Handle undo button pressed
    @IBAction func undoPressed(_ sender: UIButton) {
        if (undoStack.size > 0) {
            let color = undoStack.popColor()
            let number = undoStack.popNumber()
            let prevLastPressed = undoStack.popPrevLastPressed()
            if (color == 0) {
                redButtonArray[number - 1].backgroundColor = redColor
                redLastPressed = prevLastPressed
                numRedPressed -= 1
            }
            else if (color == 1) {
                yellowButtonArray[number - 1].backgroundColor = yellowColor
                yellowLastPressed = prevLastPressed
                numYellowPressed -= 1
            }
            else if (color == 2) {
                greenButtonArray[number - 1].backgroundColor = greenColor
                greenLastPressed = prevLastPressed
                numGreenPressed -= 1
            }
            else if (color == 3) {
                blueButtonArray[number - 1].backgroundColor = blueColor
                blueLastPressed = prevLastPressed
                numBluePressed -= 1
            }
            else if (color == 4) {
                if (number == 0) {
                    miss1.setTitleColor(UIColor.white, for: UIControlState.normal)
                    numMisses -= 1
                }
                if (number == 1) {
                    miss2.setTitleColor(UIColor.white, for: UIControlState.normal)
                    numMisses -= 1
                }
                if (number == 2) {
                    miss3.setTitleColor(UIColor.white, for: UIControlState.normal)
                    numMisses -= 1
                }
                if (number == 3) {
                    miss4.setTitleColor(UIColor.white, for: UIControlState.normal)
                    numMisses -= 1
                }
            }
        }
        updateScore()
    }
    
    func gameOver() {
        
    }
    
    func updateScore() {
        switch (numRedPressed) {
        case 0:
            redScoreLabel.text = "0"
        case 1:
            redScoreLabel.text = "1"
        case 2:
            redScoreLabel.text = "3"
        case 3:
            redScoreLabel.text = "6"
        case 4:
            redScoreLabel.text = "10"
        case 5:
            redScoreLabel.text = "15"
        case 6:
            redScoreLabel.text = "21"
        case 7:
            redScoreLabel.text = "28"
        case 8:
            redScoreLabel.text = "36"
        case 9:
            redScoreLabel.text = "45"
        case 10:
            redScoreLabel.text = "55"
        case 11:
            redScoreLabel.text = "66"
        case 12:
            redScoreLabel.text = "78"
        default:
            break
        }
        
        switch (numYellowPressed) {
        case 0:
            yellowScoreLabel.text = "0"
        case 1:
            yellowScoreLabel.text = "1"
        case 2:
            yellowScoreLabel.text = "3"
        case 3:
            yellowScoreLabel.text = "6"
        case 4:
            yellowScoreLabel.text = "10"
        case 5:
            yellowScoreLabel.text = "15"
        case 6:
            yellowScoreLabel.text = "21"
        case 7:
            yellowScoreLabel.text = "28"
        case 8:
            yellowScoreLabel.text = "36"
        case 9:
            yellowScoreLabel.text = "45"
        case 10:
            yellowScoreLabel.text = "55"
        case 11:
            yellowScoreLabel.text = "66"
        case 12:
            yellowScoreLabel.text = "78"
        default:
            break
        }
        
        switch (numGreenPressed) {
        case 0:
            greenScoreLabel.text = "0"
        case 1:
            greenScoreLabel.text = "1"
        case 2:
            greenScoreLabel.text = "3"
        case 3:
            greenScoreLabel.text = "6"
        case 4:
            greenScoreLabel.text = "10"
        case 5:
            greenScoreLabel.text = "15"
        case 6:
            greenScoreLabel.text = "21"
        case 7:
            greenScoreLabel.text = "28"
        case 8:
            greenScoreLabel.text = "36"
        case 9:
            greenScoreLabel.text = "45"
        case 10:
            greenScoreLabel.text = "55"
        case 11:
            greenScoreLabel.text = "66"
        case 12:
            greenScoreLabel.text = "78"
        default:
            break
        }
        
        switch (numBluePressed) {
        case 0:
            blueScoreLabel.text = "0"
        case 1:
            blueScoreLabel.text = "1"
        case 2:
            blueScoreLabel.text = "3"
        case 3:
            blueScoreLabel.text = "6"
        case 4:
            blueScoreLabel.text = "10"
        case 5:
            blueScoreLabel.text = "15"
        case 6:
            blueScoreLabel.text = "21"
        case 7:
            blueScoreLabel.text = "28"
        case 8:
            blueScoreLabel.text = "36"
        case 9:
            blueScoreLabel.text = "45"
        case 10:
            blueScoreLabel.text = "55"
        case 11:
            blueScoreLabel.text = "66"
        case 12:
            blueScoreLabel.text = "78"
        default:
            break
        }
        
        switch (numMisses) {
        case 0:
            missScoreLabel.text = "0"
        case 1:
            missScoreLabel.text = "5"
        case 2:
            missScoreLabel.text = "10"
        case 3:
            missScoreLabel.text = "15"
        case 4:
            missScoreLabel.text = "20"
        default:
            break
        }
        
        let totalScore: Int = Int(redScoreLabel.text!)! + Int(yellowScoreLabel.text!)! + Int(greenScoreLabel.text!)! + Int(blueScoreLabel.text!)! - Int(missScoreLabel.text!)!
        totalScoreLabel.text = String(totalScore)
    }
    
    func setupButtonArrays() {
        redButtonArray = [red1, red2, red3, red4, red5, red6, red7, red8, red9, red10, red11, red12]
        yellowButtonArray = [yellow1, yellow2, yellow3, yellow4, yellow5, yellow6, yellow7, yellow8, yellow9, yellow10, yellow11, yellow12]
        greenButtonArray = [green1, green12, green11, green10, green9, green8, green7, green6, green5, green4, green3, green2]
        blueButtonArray = [blue1, blue12, blue11, blue10, blue9, blue8, blue7, blue6, blue5, blue4, blue3, blue2]
    }
    
    struct UndoStack {
        var colors = [Int]()
        var numbers = [Int]()
        var prevLastPressedArray = [Int]()
        var size: Int = 0
        mutating func push(color: Int, number: Int, prevLastPressed: Int) {
            colors.append(color)
            numbers.append(number)
            prevLastPressedArray.append(prevLastPressed)
            size += 1
        }
        
        mutating func popColor() -> Int {
            size -= 1
            return colors.removeLast()
        }
        mutating func popNumber() -> Int {
            return numbers.removeLast()
        }
        mutating func popPrevLastPressed() -> Int {
            return prevLastPressedArray.removeLast()
        }
        
        mutating func clear() {
            colors = [Int]()
            numbers = [Int]()
            prevLastPressedArray = [Int]()
            size = 0
        }
        
    }
    
}

