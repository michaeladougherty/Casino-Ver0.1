//
//  GameScene.swift
//  Casino
//
//  Created by Michael Dougherty on 1/3/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var startButton = SKLabelNode()
    var labelBackground = SKShapeNode()
    var nodeMiddle = SKSpriteNode()
    var nodeLeft = SKSpriteNode()
    var nodeRight = SKSpriteNode()
    var title = SKLabelNode()
    var music = SKAudioNode()
    var coins = UserDefaults.standard.integer(forKey: "coins")
    var coinLabel = SKLabelNode()
    var coinImage = SKSpriteNode()
    var cardsUsed: [Int] = [00, 10, 20, 30]
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0, dy: -9)
        self.backgroundColor = SKColor.titleBackgroundColor
        
        music = SKAudioNode(fileNamed: "CasinoTitle.mp3")
        self.addChild(music)
        
        loadFromUserDefaults()
        if coins < 50
        {
            coins = 50
            saveToUserDefaults()
        }
        
        run(SKAction.sequence([
                SKAction.wait(forDuration: 3.0),
                SKAction.run(createTitleLabel),
                SKAction.run(createMiddleNode),
                SKAction.run(createTitleCards),
                SKAction.wait(forDuration: 3.0),
                SKAction.run(createStartButton)
                ]))
        
    }
    
    
    //--------------------------------------------------------------------------------------------------------------------------------

    
    func createTitleCards()
    {
        let card1 = randomCard()
        card1.position = CGPoint(x: frame.width/3, y: frame.height/0.5)
        card1.size = CGSize(width: frame.width/4, height: frame.height/5.5)
        
        card1.physicsBody = SKPhysicsBody(rectangleOf: card1.frame.size)
        card1.physicsBody?.allowsRotation = false
        card1.physicsBody?.friction = 0
        card1.physicsBody?.affectedByGravity = true
        card1.physicsBody?.restitution = 0.25
        card1.physicsBody?.angularDamping = 0
        card1.physicsBody?.linearDamping = 0
        addChild(card1)

        let card2 = randomCard()
        card2.position = CGPoint(x: frame.width/1.5, y: frame.height/0.5)
        card2.size = CGSize(width: frame.width/4, height: frame.height/5.5) // Ratio of cards is 8 Width and 11 Height

        card2.physicsBody = SKPhysicsBody(rectangleOf: card2.frame.size)
        card2.physicsBody?.allowsRotation = false
        card2.physicsBody?.friction = 0
        card2.physicsBody?.affectedByGravity = true
        card2.physicsBody?.restitution = 0.25
        card2.physicsBody?.angularDamping = 0
        card2.physicsBody?.linearDamping = 0
        addChild(card2)
        
    }
    
    
    //--------------------------------------------------------------------------------------------------------------------------------
    
    
    func createStartButton()
    {
        labelBackground = SKShapeNode(rectOf: CGSize(width: frame.width/3, height: frame.height/10), cornerRadius: CGFloat(10))
        labelBackground.position = CGPoint(x: frame.width/2, y: frame.height/3.75)  //Middle of Screen
        labelBackground.glowWidth = 1.0
        labelBackground.fillColor = SKColor.startButtonBackground
        labelBackground.strokeColor = SKColor.palletGray3
        labelBackground.name = "startButton"
        addChild(labelBackground)
        
        startButton = SKLabelNode(text: "Start")
        startButton.fontName = "Herborn"
        startButton.fontSize = CGFloat(frame.width/12)
        startButton.position = CGPoint(x: frame.width/2, y: frame.height/4)
        startButton.name = "startButton"
        addChild(startButton)
    }
    
    
    //--------------------------------------------------------------------------------------------------------------------------------

    
    func createMiddleNode()
    {
        nodeMiddle = SKSpriteNode(color: .clear, size: CGSize(width: frame.width*2, height: 10))
        nodeMiddle.position = CGPoint(x: 0, y: frame.height/2.5)
        addChild(nodeMiddle)
        nodeMiddle.physicsBody = SKPhysicsBody(rectangleOf: nodeMiddle.frame.size)
        nodeMiddle.physicsBody?.isDynamic = false
        nodeMiddle.name = "middle"
        
        
        nodeLeft = SKSpriteNode(color: .clear, size: CGSize(width: 10, height: frame.height*2))
        nodeLeft.position = CGPoint(x: 0, y: frame.height/2)
        addChild(nodeLeft)
        nodeLeft.physicsBody = SKPhysicsBody(rectangleOf: nodeLeft.frame.size)
        nodeLeft.physicsBody?.isDynamic = false
        nodeLeft.name = "left"
        
        nodeRight = SKSpriteNode(color: .clear, size: CGSize(width: 10, height: frame.height*2))
        nodeRight.position = CGPoint(x: frame.width, y: frame.height/2)
        addChild(nodeRight)
        nodeRight.physicsBody = SKPhysicsBody(rectangleOf: nodeRight.frame.size)
        nodeRight.physicsBody?.isDynamic = false
        nodeRight.name = "right"
    }
    
    
    //--------------------------------------------------------------------------------------------------------------------------------

    
    func createTitleLabel()
    {
        title = SKLabelNode(text: "Casino")
        title.fontName = "Cochin"
        title.fontSize = CGFloat(frame.width/8)
        title.position = CGPoint(x: frame.width/2, y: frame.height/1.25)
        addChild(title)
        
        coinLabel = SKLabelNode(text: "\(coins)")
        coinLabel.fontName = "absender"
        coinLabel.fontSize = CGFloat(frame.width/12)
        coinLabel.position = CGPoint(x: frame.width/2, y: frame.height/1.4-50)
        addChild(coinLabel)
        
        
        var gifTextures: [SKTexture] = [];

            for i in 1...9 {
                gifTextures.append(SKTexture(imageNamed: "coinFrame\(i)"));
            }
        
        coinImage.size = CGSize(width: frame.width/10, height: frame.width/10)
        coinImage.position = CGPoint(x: frame.width/2, y: frame.height/1.4+50)
        coinImage.run(SKAction.repeatForever(SKAction.animate(with: gifTextures, timePerFrame: 0.075)))
        addChild(coinImage)
    }

    
    //--------------------------------------------------------------------------------------------------------------------------------

    
    enum CardLevel :CGFloat { // Z Level of Cards During Movement
      case board = 10
      case moving = 100
      case enlarged = 200
    }
    
        
    
    //--------------------------------------------------------------------------------------------------------------------------------

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            
            if touchedNode.name == "startButton" { // Start Button
                
                SKAction.fadeOut(withDuration: 0.5)
                let gameMenu = GameMenu(fileNamed: "GameMenu")
                gameMenu?.scaleMode = .aspectFill
                self.view?.presentScene(gameMenu!, transition: SKTransition.fade(withDuration: 1))
            }
            
            if let card = atPoint(location) as? Card { // Card movement
              card.zPosition = CardLevel.moving.rawValue
                card.physicsBody?.affectedByGravity = false
//              card.removeAction(forKey: "drop")
//              card.run(SKAction.scale(to: 1.3, duration: 0.25), withKey: "pickup") // Pickup Animation
                
              if touch.tapCount > 1 { // Card Flip Animation
                  card.flip()
                }

            }
        }
    }
    
    
    //--------------------------------------------------------------------------------------------------------------------------------

    
    //More Card Movement
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      for touch in touches {
        let location = touch.location(in: self)
        if let card = atPoint(location) as? Card {
            if location.y > frame.height/2
            {
                card.position = location
            }
        }
      }
    }
    
    
    //--------------------------------------------------------------------------------------------------------------------------------

    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      for touch in touches {
        let location = touch.location(in: self)
        if let card = atPoint(location) as? Card {
          card.zPosition = CardLevel.board.rawValue
          card.removeFromParent()
          addChild(card)
            card.physicsBody?.affectedByGravity = true
//          card.removeAction(forKey: "pickup")
//          card.run(SKAction.scale(to: 1.0, duration: 0.25), withKey: "drop")
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

    
    
    
    
    func randomCard() -> Card
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
                print("used")
            }else
            {
                newCard = true
                cardsUsed.append(intCard)
            }
        }
        var card = Card(cardType: CardType(rawValue: randomValue)!, cardSuit: CardSuit(rawValue: randomSuit)!, cardBack: CardBack(rawValue: 0)!)
        return card
    }
}
