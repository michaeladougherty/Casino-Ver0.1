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
    var betButtonBackground = SKShapeNode()
    var betButtonText = SKLabelNode()
    var betBackground = SKSpriteNode()
    var coinImage = SKSpriteNode()
    var coinBalanceLabel = SKLabelNode()
    var bettingX = 150.0
    var chipPositionY = 25.0
    var chipPositionX = 0.0
    var chipPositionZ = 23.0
    var betValue = 0
    var cancelButtonText = SKLabelNode()
    var cancelButtonBackground = SKShapeNode()
    var copiedNodes:[SKSpriteNode] = [SKSpriteNode]()

    
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
        
        self.backgroundColor = SKColor.tableGreen
        createBetScreen()

        run(SKAction.sequence([
//            SKAction.run(createBackground),
//            SKAction.run(dealerStartingDraw),
//            SKAction.wait(forDuration: 1.5),
//            SKAction.run(playerDraws),
//            SKAction.wait(forDuration: 1.5),
//            SKAction.run(dealerDraws),
//            SKAction.wait(forDuration: 1.5),
//            SKAction.run(playerDraws),
//            SKAction.run(playerCheck)
            ]))
    }
    
    
    func createBetScreen()
    {
        betValue = 0
        
        bottomBar = SKShapeNode(rectOf: CGSize(width: frame.width, height: frame.height/2.1))
        bottomBar.position = CGPoint(x: frame.width/2, y: frame.height/4.25)
        bottomBar.fillColor = UIColor.bettingScreenBackground
        bottomBar.strokeColor = UIColor.black
        bottomBar.zPosition = 15
        addChild(bottomBar)
        
        betBackground = SKSpriteNode(imageNamed: "betBackground")
        betBackground.anchorPoint = CGPoint(x: 0, y: 0)
        betBackground.position = CGPoint(x: 0, y: 0)
        betBackground.size = CGSize(width: frame.width, height: frame.height)
        betBackground.zPosition = 0
        addChild(betBackground)

        
        betButtonBackground = SKShapeNode(rectOf: CGSize(width: frame.width/3, height: frame.height/10), cornerRadius: CGFloat(10))
        betButtonBackground.position = CGPoint(x: frame.width/2, y: frame.height/9.5)  //Middle of Screen
        betButtonBackground.glowWidth = 1.0
        betButtonBackground.fillColor = SKColor.tableBrown
        betButtonBackground.strokeColor = SKColor.bettingScreenBackground
        betButtonBackground.name = "betButton"
        betButtonBackground.zPosition = 15
        addChild(betButtonBackground)
        
        betButtonText = SKLabelNode(text: "Bet")
        betButtonText.fontName = "Herborn"
        betButtonText.fontSize = CGFloat(frame.width/12)
        betButtonText.position = CGPoint(x: frame.width/2, y: frame.height/11)
        betButtonText.name = "betButton"
        betButtonText.zPosition = 20
        addChild(betButtonText)
        
        
        cancelButtonBackground = SKShapeNode(rectOf: CGSize(width: frame.width/5, height: frame.height/16), cornerRadius: CGFloat(10))
        cancelButtonBackground.position = CGPoint(x: frame.width/1.25, y: frame.height/1.1)
        cancelButtonBackground.glowWidth = 1.0
        cancelButtonBackground.fillColor = SKColor.tableBrown
        cancelButtonBackground.strokeColor = SKColor.bettingScreenBackground
        cancelButtonBackground.name = "cancelButton"
        cancelButtonBackground.zPosition = 15
        addChild(cancelButtonBackground)
        
        cancelButtonText = SKLabelNode(text: "Cancel")
        cancelButtonText.fontName = "Herborn"
        cancelButtonText.fontSize = CGFloat(frame.width/28)
        cancelButtonText.position = CGPoint(x: frame.width/1.25, y: frame.height/1.11)
        cancelButtonText.name = "cancelButton"
        cancelButtonText.zPosition = 20
        addChild(cancelButtonText)
        
        
        var gifTextures: [SKTexture] = [];

            for i in 1...9 {
                gifTextures.append(SKTexture(imageNamed: "coinFrame\(i)"));
            }

        coinImage.size = CGSize(width: frame.width/10, height: frame.width/10)
        coinImage.position = CGPoint(x: frame.width/2, y: frame.height/1.1)
        coinImage.zPosition = 100
        coinImage.run(SKAction.repeatForever(SKAction.animate(with: gifTextures, timePerFrame: 0.075)))
        addChild(coinImage)


        
        bettingChips()

    }
    
    func bettingChips()
    {
        var bettingChipX = frame.width - frame.width + bettingX
        
        coinBalanceLabel = SKLabelNode(text: "\(coins - betValue)")
        coinBalanceLabel.fontName = "absender"
        coinBalanceLabel.fontSize = CGFloat(frame.width/12)
        coinBalanceLabel.position = CGPoint(x: frame.width/2, y: frame.height/1.20)
        coinBalanceLabel.zPosition = 100
        addChild(coinBalanceLabel)
        
        
                
        if coins-betValue >= 1
        {
            saveToUserDefaults()
            bettingChip1 = SKSpriteNode(imageNamed: "chip1")
            bettingChip1.size = CGSize(width: frame.width/6, height: frame.width/6)
            bettingChip1.position = CGPoint(x: bettingChipX, y: frame.height/2.5)
            bettingChip1.name = "1"
            bettingChip1.zPosition = 15
            addChild(bettingChip1)
            if coins-betValue >= 5
            {
                bettingChipX += 150
                bettingChip5 = SKSpriteNode(imageNamed: "chip5")
                bettingChip5.size = CGSize(width: frame.width/6, height: frame.width/6)
                bettingChip5.position = CGPoint(x: CGFloat(bettingChipX), y: frame.height/2.5)
                bettingChip5.name = "5"
                bettingChip5.zPosition = 16
                addChild(bettingChip5)
                if coins-betValue >= 10
                {
                    bettingChipX += 150
                    bettingChip10 = SKSpriteNode(imageNamed: "chip10")
                    bettingChip10.size = CGSize(width: frame.width/6, height: frame.width/6)
                    bettingChip10.position = CGPoint(x: CGFloat(bettingChipX), y: frame.height/2.5)
                    bettingChip10.name = "10"
                    bettingChip10.zPosition = 17
                    addChild(bettingChip10)
                    if coins-betValue >= 25
                    {
                        bettingChipX += 150
                        bettingChip25 = SKSpriteNode(imageNamed: "chip25")
                        bettingChip25.size = CGSize(width: frame.width/6, height: frame.width/6)
                        bettingChip25.position = CGPoint(x: CGFloat(bettingChipX), y: frame.height/2.5)
                        bettingChip25.name = "25"
                        bettingChip25.zPosition = 18
                        addChild(bettingChip25)
                        
                        
        if coins-betValue >= 50
        {
            bettingChipX = frame.width/5
            bettingChip50 = SKSpriteNode(imageNamed: "chip50")
            bettingChip50.size = CGSize(width: frame.width/6, height: frame.width/6)
            bettingChip50.position = CGPoint(x: CGFloat(bettingChipX), y: frame.height/2.5-150)
            bettingChip50.name = "50"
            bettingChip50.zPosition = 19
            addChild(bettingChip50)
            if coins-betValue >= 100
            {
                bettingChipX += 150
                bettingChip100 = SKSpriteNode(imageNamed: "chip100")
                bettingChip100.size = CGSize(width: frame.width/6, height: frame.width/6)
                bettingChip100.position = CGPoint(x: CGFloat(bettingChipX), y: frame.height/2.5-150)
                bettingChip100.name = "100"
                bettingChip100.zPosition = 20
                addChild(bettingChip100)
                if coins-betValue >= 250
                {
                    bettingChipX += 150
                    bettingChip250 = SKSpriteNode(imageNamed: "chip250")
                    bettingChip250.size = CGSize(width: frame.width/6, height: frame.width/6)
                    bettingChip250.position = CGPoint(x: CGFloat(bettingChipX), y: frame.height/2.5-150)
                    bettingChip250.name = "250"
                    bettingChip250.zPosition = 21
                    addChild(bettingChip250)
                    if coins-betValue >= 500
                    {
                        bettingChipX += 150
                        bettingChip500 = SKSpriteNode(imageNamed: "chip500")
                        bettingChip500.size = CGSize(width: frame.width/6, height: frame.width/6)
                        bettingChip500.position = CGPoint(x: CGFloat(bettingChipX), y: frame.height/2.5-150)
                        bettingChip500.name = "500"
                        bettingChip500.zPosition = 22
                        addChild(bettingChip500)

                    }

                }
            }
        }
                    }
                }
            }
        }
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
            
            
            
            
                //Bet Screen Code -----------------------------------------------------------------
            else if touchedNode.name == "1"
                {
                    let copiedNode = bettingChip1.copy() as! SKSpriteNode
                    copiedNode.run(SKAction.move(to: CGPoint(x: frame.width/4+chipPositionX, y: frame.height/1.8+chipPositionY), duration: 1))
                    copiedNode.zPosition = chipPositionZ
                    betValue += 1
                    removeChildren(in: [bettingChip1, bettingChip5, bettingChip10, bettingChip25, bettingChip50, bettingChip100, bettingChip250, bettingChip500, coinBalanceLabel])
                    bettingChips()
                    copiedNodes.append(copiedNode)
                        if frame.height/1.8 + chipPositionY <= frame.height/1.5
                        {
                            chipPositionY += 25
                            chipPositionZ += 1
                        }else if frame.width/4 + chipPositionX < frame.width/1.5
                        {
                            chipPositionX += 130
                            chipPositionY = 25
                            chipPositionZ += 1
                        }else
                        {
                            bettingChip1.name = ""
                            bettingChip5.name = ""
                            bettingChip10.name = ""
                            bettingChip25.name = ""
                            bettingChip50.name = ""
                            bettingChip100.name = ""
                            bettingChip250.name = ""
                            bettingChip500.name = ""
                        }
                    copiedNode.name = ""
                    addChild(copiedNode)
                
                }else if touchedNode.name == "5"
                {
                    let copiedNode = bettingChip5.copy() as! SKSpriteNode
                    copiedNode.run(SKAction.move(to: CGPoint(x: frame.width/4+chipPositionX, y: frame.height/1.8+chipPositionY), duration: 1))
                    copiedNode.zPosition = chipPositionZ
                    betValue += 5
                    copiedNodes.append(copiedNode)
                    removeChildren(in: [bettingChip1, bettingChip5, bettingChip10, bettingChip25, bettingChip50, bettingChip100, bettingChip250, bettingChip500, coinBalanceLabel])
                    bettingChips()
                        if frame.height/1.8 + chipPositionY <= frame.height/1.5
                        {
                            chipPositionY += 25
                            chipPositionZ += 1
                        }else if frame.width/4 + chipPositionX < frame.width/1.5
                        {
                            chipPositionX += 130
                            chipPositionY = 25
                            chipPositionZ += 1
                        }else
                        {
                            bettingChip1.name = ""
                            bettingChip5.name = ""
                            bettingChip10.name = ""
                            bettingChip25.name = ""
                            bettingChip50.name = ""
                            bettingChip100.name = ""
                            bettingChip250.name = ""
                            bettingChip500.name = ""
                        }
                    copiedNode.name = ""
                    addChild(copiedNode)
                    
                }else if touchedNode.name == "10"
                {
                    let copiedNode = bettingChip10.copy() as! SKSpriteNode
                    copiedNode.run(SKAction.move(to: CGPoint(x: frame.width/4+chipPositionX, y: frame.height/1.8+chipPositionY), duration: 1))
                    copiedNode.zPosition = chipPositionZ
                    betValue += 10
                    copiedNodes.append(copiedNode)
                    removeChildren(in: [bettingChip1, bettingChip5, bettingChip10, bettingChip25, bettingChip50, bettingChip100, bettingChip250, bettingChip500, coinBalanceLabel])
                    bettingChips()
                        if frame.height/1.8 + chipPositionY <= frame.height/1.5
                        {
                            chipPositionY += 25
                            chipPositionZ += 1
                        }else if frame.width/4 + chipPositionX < frame.width/1.5
                        {
                            chipPositionX += 130
                            chipPositionY = 25
                            chipPositionZ += 1
                        }else
                        {
                            bettingChip1.name = ""
                            bettingChip5.name = ""
                            bettingChip10.name = ""
                            bettingChip25.name = ""
                            bettingChip50.name = ""
                            bettingChip100.name = ""
                            bettingChip250.name = ""
                            bettingChip500.name = ""
                        }
                    copiedNode.name = ""
                    addChild(copiedNode)
                    
                }else if touchedNode.name == "25"
                {
                    let copiedNode = bettingChip25.copy() as! SKSpriteNode
                    copiedNode.run(SKAction.move(to: CGPoint(x: frame.width/4+chipPositionX, y: frame.height/1.8+chipPositionY), duration: 1))
                    copiedNode.zPosition = chipPositionZ
                    betValue += 25
                    copiedNodes.append(copiedNode)
                    removeChildren(in: [bettingChip1, bettingChip5, bettingChip10, bettingChip25, bettingChip50, bettingChip100, bettingChip250, bettingChip500, coinBalanceLabel])
                    bettingChips()
                        if frame.height/1.8 + chipPositionY <= frame.height/1.5
                        {
                            chipPositionY += 25
                            chipPositionZ += 1
                        }else if frame.width/4 + chipPositionX < frame.width/1.5
                        {
                            chipPositionX += 130
                            chipPositionY = 25
                            chipPositionZ += 1
                        }else
                        {
                            bettingChip1.name = ""
                            bettingChip5.name = ""
                            bettingChip10.name = ""
                            bettingChip25.name = ""
                            bettingChip50.name = ""
                            bettingChip100.name = ""
                            bettingChip250.name = ""
                            bettingChip500.name = ""
                        }
                    copiedNode.name = ""
                    addChild(copiedNode)
                    
                }else if touchedNode.name == "50"
                {
                    let copiedNode = bettingChip50.copy() as! SKSpriteNode
                    copiedNode.run(SKAction.move(to: CGPoint(x: frame.width/4+chipPositionX, y: frame.height/1.8+chipPositionY), duration: 1))
                    copiedNode.zPosition = chipPositionZ
                    betValue += 50
                    copiedNodes.append(copiedNode)
                    removeChildren(in: [bettingChip1, bettingChip5, bettingChip10, bettingChip25, bettingChip50, bettingChip100, bettingChip250, bettingChip500, coinBalanceLabel])
                    bettingChips()
                        if frame.height/1.8 + chipPositionY <= frame.height/1.5
                        {
                            chipPositionY += 25
                            chipPositionZ += 1
                        }else if frame.width/4 + chipPositionX < frame.width/1.5
                        {
                            chipPositionX += 130
                            chipPositionY = 25
                            chipPositionZ += 1
                        }else
                        {
                            bettingChip1.name = ""
                            bettingChip5.name = ""
                            bettingChip10.name = ""
                            bettingChip25.name = ""
                            bettingChip50.name = ""
                            bettingChip100.name = ""
                            bettingChip250.name = ""
                            bettingChip500.name = ""
                        }
                    copiedNode.name = ""
                    addChild(copiedNode)
                    
                }else if touchedNode.name == "100"
                {
                    let copiedNode = bettingChip100.copy() as! SKSpriteNode
                    copiedNode.run(SKAction.move(to: CGPoint(x: frame.width/4+chipPositionX, y: frame.height/1.8+chipPositionY), duration: 1))
                    copiedNode.zPosition = chipPositionZ
                    betValue += 100
                    copiedNodes.append(copiedNode)
                    removeChildren(in: [bettingChip1, bettingChip5, bettingChip10, bettingChip25, bettingChip50, bettingChip100, bettingChip250, bettingChip500, coinBalanceLabel])
                    bettingChips()
                        if frame.height/1.8 + chipPositionY <= frame.height/1.5
                        {
                            chipPositionY += 25
                            chipPositionZ += 1
                        }else if frame.width/4 + chipPositionX < frame.width/1.5
                        {
                            chipPositionX += 130
                            chipPositionY = 25
                            chipPositionZ += 1
                        }else
                        {
                            bettingChip1.name = ""
                            bettingChip5.name = ""
                            bettingChip10.name = ""
                            bettingChip25.name = ""
                            bettingChip50.name = ""
                            bettingChip100.name = ""
                            bettingChip250.name = ""
                            bettingChip500.name = ""
                        }
                    copiedNode.name = ""
                    addChild(copiedNode)
                    
                }else if touchedNode.name == "250"
                {
                    let copiedNode = bettingChip250.copy() as! SKSpriteNode
                    copiedNode.run(SKAction.move(to: CGPoint(x: frame.width/4+chipPositionX, y: frame.height/1.8+chipPositionY), duration: 1))
                    copiedNode.zPosition = chipPositionZ
                    betValue += 250
                    copiedNodes.append(copiedNode)
                    removeChildren(in: [bettingChip1, bettingChip5, bettingChip10, bettingChip25, bettingChip50, bettingChip100, bettingChip250, bettingChip500, coinBalanceLabel])
                    bettingChips()
                        if frame.height/1.8 + chipPositionY <= frame.height/1.5
                        {
                            chipPositionY += 25
                            chipPositionZ += 1
                        }else if frame.width/4 + chipPositionX < frame.width/1.5
                        {
                            chipPositionX += 130
                            chipPositionY = 25
                            chipPositionZ += 1
                        }else
                        {
                            bettingChip1.name = ""
                            bettingChip5.name = ""
                            bettingChip10.name = ""
                            bettingChip25.name = ""
                            bettingChip50.name = ""
                            bettingChip100.name = ""
                            bettingChip250.name = ""
                            bettingChip500.name = ""
                        }
                    copiedNode.name = ""
                    addChild(copiedNode)
                    
                }else if touchedNode.name == "500"
                {
                        let copiedNode = bettingChip500.copy() as! SKSpriteNode
                        copiedNode.run(SKAction.move(to: CGPoint(x: frame.width/4+chipPositionX, y: frame.height/1.8+chipPositionY), duration: 1))
                        copiedNode.zPosition = chipPositionZ
                        betValue += 500
                        copiedNodes.append(copiedNode)
                        removeChildren(in: [bettingChip1, bettingChip5, bettingChip10, bettingChip25, bettingChip50, bettingChip100, bettingChip250, bettingChip500, coinBalanceLabel])
                        bettingChips()
                            if frame.height/1.8 + chipPositionY <= frame.height/1.5
                            {
                                chipPositionY += 25
                                chipPositionZ += 1
                            }else if frame.width/4 + chipPositionX < frame.width/1.5
                            {
                                chipPositionX += 130
                                chipPositionY = 25
                                chipPositionZ += 1
                            }else
                            {
                                bettingChip1.name = ""
                                bettingChip5.name = ""
                                bettingChip10.name = ""
                                bettingChip25.name = ""
                                bettingChip50.name = ""
                                bettingChip100.name = ""
                                bettingChip250.name = ""
                                bettingChip500.name = ""
                            }
                        copiedNode.name = ""
                        addChild(copiedNode)
                }else if touchedNode.name == "cancelButton"
                {
                    for i in copiedNodes
                    {
                        run(SKAction.sequence([
                            SKAction.run({
                                i.run(SKAction.moveTo(x: 10, duration: 0.5))}
                                        ),
                            SKAction.wait(forDuration: 0.5),
                            SKAction.run {
                                i.removeFromParent()
                            },
                            SKAction.run { [self] in
                                removeChildren(in: [bettingChip1, bettingChip5, bettingChip10, bettingChip25, bettingChip50, bettingChip100, bettingChip250, bettingChip500, coinBalanceLabel])
                                betValue = 0
                                bettingX = 150.0
                                chipPositionY = 25.0
                                chipPositionX = 0.0
                                chipPositionZ = 23.0
                                bettingChips()
                            }]
                        ))
                    }
                }else if touchedNode.name == "betButton"
                {
                    run(SKAction.sequence([
                        SKAction.run { [self] in
                            coins = coins - betValue
                            saveToUserDefaults()
                            chipPositionY = 25.0
                            chipPositionX = 0.0
                            chipPositionZ = 23.0
                            removeAllChildren()
                        },
                        SKAction.run(createBackground),
                        SKAction.run { [self] in
                            var chipCount = 0
                            for i in copiedNodes
                            {
                                let copiedNode = i.copy() as! SKSpriteNode
                                copiedNode.position = CGPoint(x: frame.width/4+chipPositionX, y: frame.height/1.8+chipPositionY)
                                copiedNode.name = ""
                                addChild(copiedNode)
                                chipPositionY += 25
                                chipPositionZ += 1
                            }
                        },
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
    
        var card = Card(cardType: CardType(rawValue: randomValue)!, cardSuit: CardSuit(rawValue: randomSuit)!, cardBack: CardBack(rawValue: 0)!)
        return card
    }

}
