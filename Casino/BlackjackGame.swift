//
//  BlackjackGame.swift
//  Casino
//
//  Created by Michael Dougherty on 1/18/23.
//

import SpriteKit
import Foundation

class BlackjackGame: SKScene
{
    
    //Game Background Values/Nodes
    var bottomBar = SKShapeNode()
    var cardHolder = SKShapeNode()
    var cardBack1 = SKSpriteNode()
    var cardBack2 = SKSpriteNode()
    var cardBack3 = SKSpriteNode()
    var cardBack4 = SKSpriteNode()
    var cardBack5 = SKSpriteNode()
    var dealerNode = SKSpriteNode()
    var hitButtonBackground = SKShapeNode()
    var hitButtonText = SKLabelNode()
    var standButtonBackground = SKShapeNode()
    var standButtonText = SKLabelNode()
    var dealerScoreLabel = SKLabelNode()
    var playerScoreLabel = SKLabelNode()
    
    
    //Game Card Mechanic Values and Player/Dealer Values
    var firstDealerCard = Card(cardType: .joker, cardSuit: .club, cardBack: .white)
    var playerCount = 75.0
    var dealerCount = 75.0
    var count2 = 0
    var dealerCard1 = Card(cardType: .jester, cardSuit: .diamond, cardBack: .white)
    var playersTurn = true
    var dealerOrPlayer = 0
    var win = false
    var dealerStop = false
    
    //Other Values
    var bustLabel = SKLabelNode()
    var enlarged = false
    var gameStarted = false
    var coins = UserDefaults.standard.integer(forKey: "coins")
    
    
    //Betting Screen Values/Nodes
    var bettingChip1 = SKSpriteNode()
    var bettingChip5 = SKSpriteNode()
    var bettingChip10 = SKSpriteNode()
    var bettingChip25 = SKSpriteNode()
    var bettingChip50 = SKSpriteNode()
    var bettingChip100 = SKSpriteNode()
    var bettingChip250 = SKSpriteNode()
    var bettingChip500 = SKSpriteNode()
    var bettingChip1000 = SKSpriteNode()

    
    //Card Values/Nodes
    var dealerScore = 0
    var playerScore = 0
    var dealerCards: [Int] = []
    var playerCards: [Int] = []
    var cardsUsed: [Int] = [00, 10, 20, 30]
    var cardPositionX: [CGFloat] = []
    var cardZValue: CGFloat = 0.0
    
    override func didMove(to view: SKView) {
        loadFromUserDefaults()
        
        self.backgroundColor = SKColor.tablwGreen
        createBetScreen()
        run(SKAction.sequence([
            SKAction.run(createBackground),
            SKAction.run(dealerStartingDraw),
            SKAction.wait(forDuration: 1.5),
            SKAction.run(playerDraws),
            SKAction.wait(forDuration: 1.5),
            SKAction.run(dealerDraws),
            SKAction.wait(forDuration: 1.5),
            SKAction.run(playerDraws),
            SKAction.run(playerCheck)
            ]))
    }
    
    
    func createBetScreen()
    {
        bottomBar = SKShapeNode(rectOf: CGSize(width: frame.width, height: frame.height/1.5))
        bottomBar.position = CGPoint(x: frame.width/2, y: frame.height/4)
        bottomBar.fillColor = UIColor.tableBrown
        bottomBar.strokeColor = UIColor.black
        addChild(bottomBar)
    }
    
    func bettingChips()
    {
        
    }
    
    
    
    func createBackground()
    {
        removeChildren(in: [bottomBar])
        bottomBar = SKShapeNode(rectOf: CGSize(width: frame.width, height: frame.height/3))
        bottomBar.position = CGPoint(x: frame.width/2, y: frame.height/6)
        bottomBar.fillColor = UIColor.tableBrown
        bottomBar.strokeColor = UIColor.black
        addChild(bottomBar) //Creates brown bottom bar for buttons and bottom of cards
        
            cardBack1 = SKSpriteNode(imageNamed: "cardBackWhite")
            cardBack1.size = CGSize(width: frame.width/4.88, height: frame.width/3.55)
            cardBack1.position = CGPoint(x: frame.width/1.3, y: frame.height/1.160)
            addChild(cardBack1)
            cardBack2 = SKSpriteNode(imageNamed: "cardBackWhite")
            cardBack2.size = CGSize(width: frame.width/4.88, height: frame.width/3.55)
            cardBack2.position = CGPoint(x: frame.width/1.3, y: frame.height/1.180)
            addChild(cardBack2)
            cardBack3 = SKSpriteNode(imageNamed: "cardBackWhite")
            cardBack3.size = CGSize(width: frame.width/4.88, height: frame.width/3.55)
            cardBack3.position = CGPoint(x: frame.width/1.3, y: frame.height/1.195)
            addChild(cardBack3)
            cardBack4 = SKSpriteNode(imageNamed: "cardBackWhite")
            cardBack4.size = CGSize(width: frame.width/4.88, height: frame.width/3.55)
            cardBack4.position = CGPoint(x: frame.width/1.3, y: frame.height/1.215)
            addChild(cardBack4)
            cardBack5 = SKSpriteNode(imageNamed: "cardBackWhite")
            cardBack5.size = CGSize(width: frame.width/4.88, height: frame.width/3.55)
            cardBack5.position = CGPoint(x: frame.width/1.3, y: frame.height/1.235)
            addChild(cardBack5) //Different nodes for the creation of stack of cards
        
        
        hitButtonBackground = SKShapeNode(rectOf: CGSize(width: frame.width/3, height: frame.height/10), cornerRadius: CGFloat(10))
        hitButtonBackground.position = CGPoint(x: frame.width/3.5, y: frame.height/9.5)  //Middle of Screen
        hitButtonBackground.glowWidth = 1.0
        hitButtonBackground.fillColor = SKColor.blackJackButtons
        hitButtonBackground.strokeColor = SKColor.tableBrown
        hitButtonBackground.name = "hitButton"
        addChild(hitButtonBackground) //Creation of the Rectangle behind the Hit button
        
        hitButtonText = SKLabelNode(text: "Hit")
        hitButtonText.fontName = "Herborn"
        hitButtonText.fontSize = CGFloat(frame.width/12)
        hitButtonText.position = CGPoint(x: frame.width/3.5, y: frame.height/11.5)
        hitButtonText.name = "hitButton"
        addChild(hitButtonText) //Creation of the letters for the hit button
        
        
        standButtonBackground = SKShapeNode(rectOf: CGSize(width: frame.width/3, height: frame.height/10), cornerRadius: CGFloat(10))
        standButtonBackground.position = CGPoint(x: frame.width/1.4, y: frame.height/9.5)  //Middle of Screen
        standButtonBackground.glowWidth = 1.0
        standButtonBackground.fillColor = SKColor.blackJackButtons
        standButtonBackground.strokeColor = SKColor.tableBrown
        standButtonBackground.name = "standButton"
        addChild(standButtonBackground) //Creation of the rectangle background for the stand button
        
        standButtonText = SKLabelNode(text: "Stand")
        standButtonText.fontName = "Herborn"
        standButtonText.fontSize = CGFloat(frame.width/12)
        standButtonText.position = CGPoint(x: frame.width/1.4, y: frame.height/11.5)
        standButtonText.name = "standButton"
        addChild(standButtonText) //Creation of the letters for the stand button



    }
    
    func dealerStartingDraw() //Function of the dealers first card drawn
    {
        dealerOrPlayer = 0 //Checks if it is the dealers turn or the players
        dealerCount += 100 //Sets the x positional value for the dealers newly drawn cards
        count2 += 1 //Sets z position of new cards to make sure they do not overlay incorrectley
        let playerCardX = frame.width - frame.width + dealerCount //X value for new card created using previous value
        firstDealerCard = randomCard() //Gets a random card and assigns it to the first dealer card value
        firstDealerCard.zPosition += CGFloat(count2) //Sets the z position of the card
        firstDealerCard.size = CGSize(width: frame.width/4.88, height: frame.width/3.55)
        firstDealerCard.position = CGPoint(x: frame.width/1.3, y: frame.height/1.235)
        addChild(firstDealerCard)
        
        firstDealerCard.flipWithOutAnimation() //Flips the card to not be seen
        
        firstDealerCard.run(SKAction.scale(to: CGSize(width: frame.width/4, height: frame.width/2.909), duration: 1))
        firstDealerCard.run(SKAction.move(to: CGPoint(x: playerCardX, y: frame.height/1.195), duration: 1))
        //Card animation to place of rest
                        
    }
    
    
    func playerDraws() //Creates the function that is called to draw a card for the player
    {
        playersTurn = true //Checks for if it is players turn in code
        dealerOrPlayer = 1 //Also shows that it is players turn IDK why I used to seperate values for this I will change later
        playerCount += 100 //X value position of new cards
        count2 += 1 //Z value position of new cards
        let playerCardX = frame.width - frame.width + playerCount //Setting x value
        let card = randomCard() //Getting random card
        card.zPosition += CGFloat(count2) //Sets cards z position
        card.flipWithOutAnimation() //Flips card for back
        card.size = CGSize(width: frame.width/4.88, height: frame.width/3.55)
        card.position = CGPoint(x: frame.width/1.3, y: frame.height/1.235)
        addChild(card)
        
        
        run(SKAction.sequence([
           SKAction.run(card.flip), //Flips card again
           SKAction.wait(forDuration: 1),
           SKAction.run {
            card.run(SKAction.scale(to: CGSize(width: self.frame.width/4, height: self.frame.width/2.909), duration: 1))
            card.run(SKAction.move(to: CGPoint(x: playerCardX, y: self.frame.height/3), duration: 1))},
           //moves card to position
           SKAction.run {
            self.playerScoreLabel.removeFromParent()
            self.dealerScoreLabel.removeFromParent()
            self.scoreLabels()
            //Resets score labels to be correct
            }]))
    }
    
    func dealerDraws()
    {
        if dealerScore > playerScore && dealerScore < 22
        {
            dealerStop = true
            removeAllActions()
        }
        if dealerCards.count > 2
        {
            playersTurn = false
        }
        dealerOrPlayer = 0
        dealerCount += 75
        count2 += 1
        let playerCardX = frame.width - frame.width + dealerCount
        let card = randomCard()
        card.zPosition += CGFloat(count2)
        card.flipWithOutAnimation()
        card.size = CGSize(width: frame.width/4.88, height: frame.width/3.55)
        card.position = CGPoint(x: frame.width/1.3, y: frame.height/1.235)
        addChild(card)
        run(SKAction.sequence([
           SKAction.run(card.flip),
           SKAction.wait(forDuration: 1),
           SKAction.run {
               card.run(SKAction.scale(to: CGSize(width: self.frame.width/4, height: self.frame.width/2.909), duration: 1))
               card.run(SKAction.move(to: CGPoint(x: playerCardX, y: self.frame.height/1.195), duration: 1))},
           SKAction.run {
               self.playerScoreLabel.removeFromParent()
               self.dealerScoreLabel.removeFromParent()
               self.scoreLabels()
            }]))
        }


    
    func scoreLabels()
    {
        if dealerCards.count > 1
        {
            if playersTurn
            {
                dealerScore = dealerCards[dealerCards.count-1]
            }else
            {
                dealerScore = dealerCards.reduce(0, +)
            }
        }
        dealerScoreLabel = SKLabelNode(text: "Dealer: \(dealerScore)")
        dealerScoreLabel.fontSize = frame.width/14
        dealerScoreLabel.fontName = "Georgia"
        dealerScoreLabel.position = CGPoint(x: frame.width/2, y: frame.height/1.45)
        addChild(dealerScoreLabel)
        
        
        playerScore = playerCards.reduce(0, +)
        playerScoreLabel = SKLabelNode(text: "Player: \(playerScore)")
        playerScoreLabel.fontSize = frame.width/14
        playerScoreLabel.fontName = "Georgia"
        playerScoreLabel.position = CGPoint(x: frame.width/2, y: frame.height/2.2)
        addChild(playerScoreLabel)
        
        
    }
    
    func gameOver()
    {
        removeAllChildren()
        dealerCount = 75.0
        playerCount = 75.0
        count2 = 0
        dealerScore = 0
        playerScore = 0
        playerCards.removeAll(keepingCapacity: false)
        dealerCards.removeAll(keepingCapacity: false)
        cardsUsed.removeAll(keepingCapacity: false)
        cardPositionX.removeAll(keepingCapacity: false)
        var message = ""
        if win
        {
            message = "Good Job!"
        }else{
            message = "Better luck next time."
        }
        let gameEndLabel = SKLabelNode(text: "\(message) \n\nWould you like to play again?")
        gameEndLabel.position = CGPoint(x: frame.width/2, y: frame.height/1.65)
        gameEndLabel.fontSize = frame.width/12
        gameEndLabel.fontName = "Cochin"
        gameEndLabel.numberOfLines = 0
        gameEndLabel.preferredMaxLayoutWidth = frame.width-100
        addChild(gameEndLabel)
        
        
        let  playAgainButton = SKShapeNode(rectOf: CGSize(width: frame.width/2.5, height: frame.height/10), cornerRadius: CGFloat(10))
        playAgainButton.position = CGPoint(x: frame.width/2, y: frame.height/2.25)
        playAgainButton.fillColor = UIColor.startButtonBackground
        playAgainButton.strokeColor = UIColor.palletGreen1
        playAgainButton.name = "playAgain"
        addChild(playAgainButton)
        
        let playAgainLabel = SKLabelNode(text: "Play Again")
        playAgainLabel.position = CGPoint(x: frame.width/2, y: frame.height/2.33)
        playAgainLabel.fontName = "Herborn"
        playAgainLabel.fontSize = frame.width/15
        playAgainLabel.name = "playAgain"
        addChild(playAgainLabel)
        
        
        let  gameMenuButton = SKShapeNode(rectOf: CGSize(width: frame.width/2.5, height: frame.height/10), cornerRadius: CGFloat(10))
        gameMenuButton.position = CGPoint(x: frame.width/2, y: frame.height/3.0)
        gameMenuButton.fillColor = UIColor.startButtonBackground
        gameMenuButton.strokeColor = UIColor.palletGreen1
        gameMenuButton.name = "gameMenu"
        addChild(gameMenuButton)
        
        let gameMenuLabel = SKLabelNode(text: "Menu")
        gameMenuLabel.position = CGPoint(x: frame.width/2, y: frame.height/3.15)
        gameMenuLabel.fontName = "Herborn"
        gameMenuLabel.fontSize = frame.width/15
        gameMenuLabel.name = "gameMenu"
        addChild(gameMenuLabel)

        
        let  titleButton = SKShapeNode(rectOf: CGSize(width: frame.width/2.5, height: frame.height/10), cornerRadius: CGFloat(10))
        titleButton.position = CGPoint(x: frame.width/2, y: frame.height/4.5)
        titleButton.fillColor = UIColor.startButtonBackground
        titleButton.strokeColor = UIColor.palletGreen1
        titleButton.name = "titleScreen"
        addChild(titleButton)
        
        let titleLabel = SKLabelNode(text: "Title")
        titleLabel.position = CGPoint(x: frame.width/2, y: frame.height/4.8)
        titleLabel.fontName = "Herborn"
        titleLabel.fontSize = frame.width/15
        titleLabel.name = "titleScreen"
        addChild(titleLabel)
    }
    
    
    func playerCheck()
    {
        if playerCards.reduce(0, +) > 21
        {
            print(playerScore)
            let bustLabel = SKLabelNode(text: "Bust")
            bustLabel.fontSize = frame.width/10
            bustLabel.fontName = "Georgia"
            bustLabel.position = CGPoint(x: frame.width/2, y: frame.height/1.75)
            addChild(bustLabel)
            win = false
            run(SKAction.sequence([
                SKAction.wait(forDuration:3.5),
                SKAction.run(gameOver)
            ]))
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            if location.y < frame.height/2
            {
                if let card = atPoint(location) as? Card { //Checking if card ENUm is the one that is pressed enlarges if it is not yet enlarged
                    cardPositionX.append(CGFloat(card.position.x))
                    if enlarged == false
                    {
                        cardZValue = card.zPosition
                        card.zPosition = 100
                        print(card.position.x)
                        card.run(SKAction.scale(to: 2.5, duration: 0.25))
                        card.run(SKAction.moveTo(x: frame.width/2, duration: 0.25))
                    }else{
                        run(SKAction.sequence([
                            SKAction.run {
                                card.run(SKAction.scale(to: 1.25, duration: 0.25))
                                card.run(SKAction.moveTo(x: self.cardPositionX[self.cardPositionX.count-2], duration: 0.25))
                            },
                            SKAction.wait(forDuration: 0.25),
                            SKAction.run {
                                card.zPosition = self.cardZValue
                            }]))
//                        card.run(SKAction.scale(to: 1.25, duration: 0.25))
//                        card.run(SKAction.moveTo(x: cardPositionX[cardPositionX.count-2], duration: 0.25))
//                        card.zPosition = cardZValue
                    }
                    enlarged = !enlarged
                }
            }

            
                if touchedNode.name == "hitButton"
                {
                    print("Hit")
                    playerDraws()
                    if playerCards.reduce(0, +) > 21
                    {
                        run(SKAction.sequence([
                            SKAction.wait(forDuration: 3),
                            SKAction.run {
                                print(self.playerScore, (self.playerCards.reduce(0, +)))
                                let bustLabel = SKLabelNode(text: "Bust")
                                bustLabel.fontSize = self.frame.width/10
                                bustLabel.fontName = "Georgia"
                                bustLabel.position = CGPoint(x: self.frame.width/2, y: self.frame.height/1.75)
                                self.addChild(bustLabel)
                                self.win = false
                                self.run(SKAction.sequence([
                                    SKAction.wait(forDuration:3.5),
                                    SKAction.run(self.gameOver)
                                ]))

                            }]))
                        }
                }else if touchedNode.name == "standButton"
                {
                    print("stand")
                    run(SKAction.sequence([SKAction.run {
                        self.firstDealerCard.flip()
                        self.firstDealerCard.size = CGSize(width: self.frame.width/4, height: self.frame.width/2.909)
                        self.playersTurn = false
                        self.dealerScoreLabel.removeFromParent()
                        self.playerScoreLabel.removeFromParent()
                        self.scoreLabels()
                    },
                        SKAction.wait(forDuration: 2),
                        SKAction.run {
                        if self.dealerScore < self.playerScore //REDUNDANT ASS CODE I FUCKING HATE THIS
                        {
                            self.dealerDraws()
                        }
                    },
                       SKAction.wait(forDuration: 1.25),
                        SKAction.run {
                        if self.dealerScore < self.playerScore
                        {
                            self.dealerDraws()
                        }
                    },
                       SKAction.wait(forDuration: 1.25),
                       SKAction.run {
                       if self.dealerScore < self.playerScore
                       {
                           self.dealerDraws()
                       }
                   },
                       SKAction.wait(forDuration: 1.25),
                       SKAction.run {
                       if self.dealerScore < self.playerScore
                       {
                           self.dealerDraws()
                       }
                   },
                       SKAction.wait(forDuration: 1.25),
                       SKAction.run {
                       if self.dealerScore < self.playerScore
                       {
                           self.dealerDraws()
                       }
                   },
                       SKAction.wait(forDuration: 1.25),
                       SKAction.run {
                       if self.dealerScore < self.playerScore
                       {
                           self.dealerDraws()
                       }
                   },

                        SKAction.run { [self] in
                        if self.dealerScore >= self.playerScore && self.dealerScore < 22
                        {
                            self.bustLabel = SKLabelNode(text: "Dealer Wins")
                            bustLabel.fontSize = frame.width/10
                            bustLabel.fontName = "Georgia"
                            bustLabel.position = CGPoint(x: frame.width/2, y: frame.height/1.75)
                            addChild(bustLabel)
                            self.win = false
                            run(SKAction.sequence([
                                SKAction.wait(forDuration:3.5),
                                SKAction.run(self.gameOver)
                            ]))
                        }else if self.dealerScore > 21
                        {
                            bustLabel = SKLabelNode(text: "Dealer Bust")
                            bustLabel.fontSize = frame.width/10
                            bustLabel.fontName = "Georgia"
                            bustLabel.position = CGPoint(x: frame.width/2, y: frame.height/1.75)
                            addChild(bustLabel)
                            self.win = true
                            run(SKAction.sequence([
                                SKAction.wait(forDuration:3.5),
                                SKAction.run(self.gameOver)
                            ]))
                        }

                    }]))
                
                    

                }else if touchedNode.name == "playAgain"
                {
                    removeAllChildren()
                    createBackground()
                    scoreLabels()
                    run(SKAction.sequence([
                        SKAction.run(dealerStartingDraw),
                        SKAction.wait(forDuration: 1.5),
                        SKAction.run(playerDraws),
                        SKAction.wait(forDuration: 1.5),
                        SKAction.run(dealerDraws),
                        SKAction.wait(forDuration: 1.5),
                        SKAction.run(playerDraws),
                        SKAction.run(playerCheck)
                        ]))                }else if touchedNode.name == "gameMenu"
                {
                    let gameMenu = GameMenu(fileNamed: "GameMenu")
                    gameMenu?.scaleMode = .aspectFill
                    self.view?.presentScene(gameMenu!, transition: SKTransition.fade(withDuration: 1))
                }else if touchedNode.name == "titleScreen"
                {
                    let gameScene = GameScene(fileNamed: "GameScene")
                    gameScene?.scaleMode = .aspectFill
                    self.view?.presentScene(gameScene!, transition: SKTransition.fade(withDuration: 1))
                }
            }
        }
    
    
    
    
    func saveToUserDefaults()
    {
        let defaults = UserDefaults.standard
        defaults.set(coins, forKey: "coins")
    }

    func loadFromUserDefaults()
    {
        let defaults = UserDefaults.standard
        
         defaults.integer(forKey: "coins")
    }
    
    
    
    
    
    func randomCard() -> Card //Creates random card function for drawing cards redundant and will try to find a way to make it better
    {
        var newCard = false
        var randomSuit = 0
        var randomValue = 0
        while newCard == false
        {
            randomSuit = Int.random(in: 0...3)
            randomValue = Int.random(in: 1...13)
            
            let stringCard = "\(randomSuit)\(randomValue)"
            let intCard = Int(stringCard) ?? 00
            print(cardsUsed)
            if cardsUsed.contains(intCard)
            {
                ""
            }else
            {
                newCard = true
                cardsUsed.append(intCard)
            }
        }
        
        if dealerOrPlayer == 0
        {
            dealerCards.append(randomValue)
            print(dealerCards)
        }else if dealerOrPlayer == 1
        {
            playerCards.append(randomValue)
            print(playerCards)
        }
    
        
        var card = Card(cardType: .eight, cardSuit: .heart, cardBack: .white)
        if randomSuit == 0
        {
            if randomValue == 1
            {
                card = Card(cardType: .ace, cardSuit: .heart, cardBack: .white)
            }else if randomValue == 2
            {
                card = Card(cardType: .two, cardSuit: .heart, cardBack: .white)
            }else if randomValue == 3
            {
                card = Card(cardType: .three, cardSuit: .heart, cardBack: .white)
            }else if randomValue == 4
            {
                card = Card(cardType: .four, cardSuit: .heart, cardBack: .white)
            }else if randomValue == 5
            {
                card = Card(cardType: .five, cardSuit: .heart, cardBack: .white)
            }else if randomValue == 6
            {
                card = Card(cardType: .six, cardSuit: .heart, cardBack: .white)
            }else if randomValue == 7
            {
                card = Card(cardType: .seven, cardSuit: .heart, cardBack: .white)
            }else if randomValue == 8
            {
                card = Card(cardType: .eight, cardSuit: .heart, cardBack: .white)
            }else if randomValue == 9
            {
                card = Card(cardType: .nine, cardSuit: .heart, cardBack: .white)
            }else if randomValue == 10
            {
                card = Card(cardType: .ten, cardSuit: .heart, cardBack: .white)
            }else if randomValue == 11
            {
                card = Card(cardType: .jester, cardSuit: .heart, cardBack: .white)
            }else if randomValue == 12
            {
                card = Card(cardType: .queen, cardSuit: .heart, cardBack: .white)
            }else if randomValue == 13
            {
                card = Card(cardType: .king, cardSuit: .heart, cardBack: .white)
            }
        }
        
        else if randomSuit == 1
        {
            if randomValue == 1
            {
                card = Card(cardType: .ace, cardSuit: .diamond, cardBack: .white)
            }else if randomValue == 2
            {
                card = Card(cardType: .two, cardSuit: .diamond, cardBack: .white)
            }else if randomValue == 3
            {
                card = Card(cardType: .three, cardSuit: .diamond, cardBack: .white)
            }else if randomValue == 4
            {
                card = Card(cardType: .four, cardSuit: .diamond, cardBack: .white)
            }else if randomValue == 5
            {
                card = Card(cardType: .five, cardSuit: .diamond, cardBack: .white)
            }else if randomValue == 6
            {
                card = Card(cardType: .six, cardSuit: .diamond, cardBack: .white)
            }else if randomValue == 7
            {
                card = Card(cardType: .seven, cardSuit: .diamond, cardBack: .white)
            }else if randomValue == 8
            {
                card = Card(cardType: .eight, cardSuit: .diamond, cardBack: .white)
            }else if randomValue == 9
            {
                card = Card(cardType: .nine, cardSuit: .diamond, cardBack: .white)
            }else if randomValue == 10
            {
                card = Card(cardType: .ten, cardSuit: .diamond, cardBack: .white)
            }else if randomValue == 11
            {
                card = Card(cardType: .jester, cardSuit: .diamond, cardBack: .white)
            }else if randomValue == 12
            {
                card = Card(cardType: .queen, cardSuit: .diamond, cardBack: .white)
            }else if randomValue == 13
            {
                card = Card(cardType: .king, cardSuit: .diamond, cardBack: .white)
            }
        }
        
        else if randomSuit == 2
        {
            if randomValue == 1
            {
                card = Card(cardType: .ace, cardSuit: .spade, cardBack: .white)
            }else if randomValue == 2
            {
                card = Card(cardType: .two, cardSuit: .spade, cardBack: .white)
            }else if randomValue == 3
            {
                card = Card(cardType: .three, cardSuit: .spade, cardBack: .white)
            }else if randomValue == 4
            {
                card = Card(cardType: .four, cardSuit: .spade, cardBack: .white)
            }else if randomValue == 5
            {
                card = Card(cardType: .five, cardSuit: .spade, cardBack: .white)
            }else if randomValue == 6
            {
                card = Card(cardType: .six, cardSuit: .spade, cardBack: .white)
            }else if randomValue == 7
            {
                card = Card(cardType: .seven, cardSuit: .spade, cardBack: .white)
            }else if randomValue == 8
            {
                card = Card(cardType: .eight, cardSuit: .spade, cardBack: .white)
            }else if randomValue == 9
            {
                card = Card(cardType: .nine, cardSuit: .spade, cardBack: .white)
            }else if randomValue == 10
            {
                card = Card(cardType: .ten, cardSuit: .spade, cardBack: .white)
            }else if randomValue == 11
            {
                card = Card(cardType: .jester, cardSuit: .spade, cardBack: .white)
            }else if randomValue == 12
            {
                card = Card(cardType: .queen, cardSuit: .spade, cardBack: .white)
            }else if randomValue == 13
            {
                card = Card(cardType: .king, cardSuit: .spade, cardBack: .white)
            }
        }
        
        else if randomSuit == 3
        {
            if randomValue == 1
            {
                card = Card(cardType: .ace, cardSuit: .club, cardBack: .white)
            }else if randomValue == 2
            {
                card = Card(cardType: .two, cardSuit: .club, cardBack: .white)
            }else if randomValue == 3
            {
                card = Card(cardType: .three, cardSuit: .club, cardBack: .white)
            }else if randomValue == 4
            {
                card = Card(cardType: .four, cardSuit: .club, cardBack: .white)
            }else if randomValue == 5
            {
                card = Card(cardType: .five, cardSuit: .club, cardBack: .white)
            }else if randomValue == 6
            {
                card = Card(cardType: .six, cardSuit: .club, cardBack: .white)
            }else if randomValue == 7
            {
                card = Card(cardType: .seven, cardSuit: .club, cardBack: .white)
            }else if randomValue == 8
            {
                card = Card(cardType: .eight, cardSuit: .club, cardBack: .white)
            }else if randomValue == 9
            {
                card = Card(cardType: .nine, cardSuit: .club, cardBack: .white)
            }else if randomValue == 10
            {
                card = Card(cardType: .ten, cardSuit: .club, cardBack: .white)
            }else if randomValue == 11
            {
                card = Card(cardType: .jester, cardSuit: .club, cardBack: .white)
            }else if randomValue == 12
            {
                card = Card(cardType: .queen, cardSuit: .club, cardBack: .white)
            }else if randomValue == 13
            {
                card = Card(cardType: .king, cardSuit: .club, cardBack: .white)
            }

        }
        return card
    }

}
