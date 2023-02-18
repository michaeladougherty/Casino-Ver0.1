//
//  GameMenu.swift
//  Casino
//
//  Created by Michael Dougherty on 1/3/23.
//

import SpriteKit
import Foundation

class GameMenu: SKScene {
    
    var buttonBack1 = SKShapeNode()
    var buttonImage1 = SKSpriteNode()
    
    var buttonBack2 = SKShapeNode()
    var buttonImage2 = SKSpriteNode()
    
    var buttonBack3 = SKShapeNode()
    var buttonImage3 = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.palletGreen1
        createButtons()
    }
    
    func createButtons()
    {
        buttonBack1 = SKShapeNode(rectOf: CGSize(width: frame.height/3.5, height: frame.height/3.5), cornerRadius: CGFloat(10))
        buttonBack1.position = CGPoint(x: frame.width/2, y: frame.height/1.25)
        buttonBack1.glowWidth = 1.0
        buttonBack1.fillColor = SKColor.startButtonBackground
        buttonBack1.strokeColor = SKColor.palletGray3
        buttonBack1.name = "blackjackButton"
        self.addChild(buttonBack1)
        
        buttonImage1 = SKSpriteNode(imageNamed: "blackjackMenu")
        buttonImage1.position = CGPoint(x: frame.width/2, y: frame.height/1.25)
        buttonImage1.size = CGSize(width: frame.height/4.5, height: frame.height/4.5)
        buttonImage1.name = "blackjackButton"
        self.addChild(buttonImage1)
        
        
        buttonBack2 = SKShapeNode(rectOf: CGSize(width: frame.height/3.5, height: frame.height/3.5), cornerRadius: CGFloat(10))
        buttonBack2.position = CGPoint(x: frame.width/2, y: frame.height/2)
        buttonBack2.glowWidth = 1.0
        buttonBack2.fillColor = SKColor.startButtonBackground
        buttonBack2.strokeColor = SKColor.palletGray3
        buttonBack2.name = "pokerButton"
        self.addChild(buttonBack2)
        
//        buttonImage2 = SKSpriteNode(imageNamed: "")
//        buttonImage2.position = CGPoint(x: frame.width/2, y: frame.height/1.25)
//        buttonImage2.size = CGSize(width: frame.height/4.5, height: frame.height/4.5)
//        buttonImage2.name = "pokerButton"
//        self.addChild(buttonImage2)

        
        
        buttonBack3 = SKShapeNode(rectOf: CGSize(width: frame.height/3.5, height: frame.height/3.5), cornerRadius: CGFloat(10))
        buttonBack3.position = CGPoint(x: frame.width/2, y: frame.height/5)
        buttonBack3.glowWidth = 1.0
        buttonBack3.fillColor = SKColor.startButtonBackground
        buttonBack3.strokeColor = SKColor.palletGray3
        buttonBack3.name = "krappsButton"
        self.addChild(buttonBack3)
        
//        buttonImage3 = SKSpriteNode(imageNamed: "")
//        buttonImage3.position = CGPoint(x: frame.width/2, y: frame.height/1.25)
//        buttonImage3.size = CGSize(width: frame.height/4.5, height: frame.height/4.5)
//        buttonImage3.name = "krappsButton"
//        self.addChild(buttonImage3)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "blackjackButton" { // Start Button
                let blackjackGame = BlackjackGame(fileNamed: "BlackjackGame")
                blackjackGame?.scaleMode = .aspectFill
                self.view?.presentScene(blackjackGame!, transition: SKTransition.fade(withDuration: 1))
            }else if touchedNode.name == "pokerButton"
            {
                let pokerGame = GameScene(fileNamed: "GameScene")
                pokerGame?.scaleMode = .aspectFill
                self.view?.presentScene(pokerGame!, transition: SKTransition.fade(withDuration: 1))
            }else if touchedNode.name == "krappsButton"
            {
                let krappsGame = GameScene(fileNamed: "GameScene")
                krappsGame?.scaleMode = .aspectFill
                self.view?.presentScene(krappsGame!, transition: SKTransition.fade(withDuration: 1))
            }
        }
    }

    }
