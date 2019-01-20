//
//  ViewController.swift
//  PIGG
//
//  Created by Jeremy Bailey on 1/19/19.
//  Copyright © 2019 Jeremy Bailey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var die1: UIImageView!
    @IBOutlet weak var die2: UIImageView!
    @IBOutlet weak var upsideDownPlayer2Score: UILabel!
    @IBOutlet weak var player1Score: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var upsideDownPlayerLable: UILabel!
    @IBOutlet weak var runPointsLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var upsideDownResetButton: UIButton!
    @IBOutlet weak var upsideDownRulesButton: UIButton!
    @IBOutlet weak var upsideDownRoll: UIButton!
    @IBOutlet weak var upsideDownPass: UIButton!
    @IBOutlet weak var upsideDownPlayer2Label: UILabel!
    @IBOutlet weak var passButton: UIButton!
    @IBOutlet weak var rollButton: UIButton!
    
    var isContinuing : Bool = false
    
    var die1Value : Int = 0
    var die2Value : Int = 0
    var playerHasRolled : Bool = false
    
    var runValue : Int = 0
    var rollValue : Int = 0
    
    var playersScore = [0,0]
    
    var isPlayer1Turn : Bool = true
    
    let dieArray = ["dice1","dice2","dice3","dice4","dice5","dice6"]
    
    let alert = UIAlertController(title: "Pig Rules", message: "Pig is a dice rolling game.  If you roll a one you'll lose the points for your current run. If you roll snake eyes you'll lose all your points. You can pass at any time after the first roll of your turn.", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        updatePlayerScores()
        updatePlayerTurnLabel()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in}))
        upsideDownPass.transform =  CGAffineTransform.init(rotationAngle: CGFloat(Float.pi))
        upsideDownRoll.transform =  CGAffineTransform.init(rotationAngle: CGFloat(Float.pi))
        upsideDownPlayerLable.transform = CGAffineTransform.init(rotationAngle: CGFloat(Float.pi))
        upsideDownResetButton.transform = CGAffineTransform.init(rotationAngle: CGFloat(Float.pi))
        upsideDownRulesButton.transform = CGAffineTransform.init(rotationAngle: CGFloat(Float.pi))
        upsideDownPlayer2Label.transform = CGAffineTransform.init(rotationAngle: CGFloat(Float.pi))
        upsideDownPlayer2Score.transform = CGAffineTransform.init(rotationAngle: CGFloat(Float.pi))
        
        rollButton.setTitleColor(UIColor.gray, for: .disabled)
        passButton.setTitleColor(UIColor.gray, for: .disabled)
        upsideDownRoll.setTitleColor(UIColor.gray, for: .disabled)
        upsideDownPass.setTitleColor(UIColor.gray, for: .disabled)
        
        ChangeButtonState()
    }

    @IBAction func RollDice(_ sender: Any) {
        RandomizeDice()
        playerHasRolled = true
        
        if (die1Value == 0 || die2Value == 0) {
            if (die1Value == 0 && die2Value == 0) {
                setPlayersScore(value: 0)
            }
            runValue = 0
            endTurn()
            return
        }
        
        runValue += die1Value + 1
        runValue += die2Value + 1
        
        runPointsLabel.text = "+\(runValue)"
    }
    
    func setPlayersScore(value: Int) {
        if (isPlayer1Turn) {
            playersScore[0] = value
        } else {
            playersScore[1] = value
        }
        updatePlayerScores()
    }
    
    func addToPlayersScore(value: Int) {
        if (isPlayer1Turn) {
            playersScore[0] += value
        } else {
            playersScore[1] += value
        }
        updatePlayerScores()
    }
    
    func updatePlayerScores() {
        player1Score.text = "\(playersScore[0])"
        upsideDownPlayer2Score.text = "\(playersScore[1])"
    }
    
    func endTurn() {
        addToPlayersScore(value: runValue)
        rollValue = 0
        die1Value = 0
        die2Value = 0
        runValue = 0
        isPlayer1Turn = !isPlayer1Turn
        updatePlayerTurnLabel()
        ChangeButtonState()
        runPointsLabel.text = "+\(runValue)"
        playerHasRolled = false
        
        var winningMessage : String = ""
        
        if (!isContinuing && (playersScore.max() ?? 0 >= 100)) {
            if (playersScore[0] >= 100) {
                winningMessage = "Congratulations Player 1"
            } else {
                winningMessage = "Congratulations Player 2"
            }
            
            let gameWonAlert = UIAlertController(title: "Game Won", message: winningMessage, preferredStyle: .alert)
            gameWonAlert.addAction(UIAlertAction(title: "Keep Playing", style: .default,
                                                 handler: { action in
                                                    self.isContinuing = true
                                                    self.resetButton.isEnabled = true
                                                    self.resetButton.isHidden = false
            }))
            gameWonAlert.addAction(UIAlertAction(title: "Rematch", style: .default, handler: {action in self.resetForRematch()}))
            
            self.present(gameWonAlert, animated:true)
        }
    }
    
    func resetForRematch() {
        rollValue = 0
        die1Value = 0
        die2Value = 0
        runValue = 0
        isPlayer1Turn = false
        setPlayersScore(value: 0)
        isPlayer1Turn = true
        setPlayersScore(value: 0)
        updatePlayerScores()
        updatePlayerTurnLabel()
        die1.image = nil
        die2.image = nil
        isContinuing = false
        resetButton.isEnabled = false
        resetButton.isHidden = true
        playerHasRolled = false
    }
    
    @IBAction func PassTurn(_ sender: Any) {
        if (playerHasRolled) {
            endTurn()
        } else {
            let haveToRoll = UIAlertController(title: "Take your turn", message: "You must roll the dice on your turn.", preferredStyle: .alert)
            haveToRoll.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(haveToRoll, animated: true)
        }
    }
    
    func RandomizeDice() {
        die1Value = Int.random(in: 0...5)
        die2Value = Int.random(in: 0...5)
        
        die1.image = UIImage(named: dieArray[die1Value])
        die2.image = UIImage(named: dieArray[die2Value])
    }
    
    func ChangeButtonState() {
        if (isPlayer1Turn) {
            upsideDownRoll.isEnabled = false
            upsideDownPass.isEnabled = false
            rollButton.isEnabled = true
            passButton.isEnabled = true
        } else {
            rollButton.isEnabled = false
            passButton.isEnabled = false
            upsideDownRoll.isEnabled = true
            upsideDownPass.isEnabled = true
        }
        
    }
    
    func updatePlayerTurnLabel() {
        if (isPlayer1Turn) {
            playerLabel.text = "Player1's turn"
        } else {
            playerLabel.text = "Player2's turn"
        }
        upsideDownPlayerLable.text = playerLabel.text
    }
    @IBAction func ShowRules(_ sender: Any) {
        self.present(alert, animated: true)
    }
    @IBAction func resetButtonPressed(_ sender: Any) {
        resetForRematch()
    }
}

