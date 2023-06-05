//
//  Card.swift
//  Casino
//
//  Created by Michael Dougherty on 1/5/23.
//

import SpriteKit

enum CardType :Int {
  case joker,
       ace,
       two,
       three,
       four,
       five,
       six,
       seven,
       eight,
       nine,
       ten,
       jester,
       queen,
       king
}

enum CardSuit :Int{
    case heart,
    diamond,
    spade,
    club
}

enum CardBack :Int{
    case white,
    black,
    blue,
    green,
    red,
    gold
}


class Card : SKSpriteNode {
    
    
    func flipSound()
    {
        let flip = SKAudioNode(fileNamed: "flipcard.mp3")
        flip.autoplayLooped = false
        self.addChild(flip)
        self.run(SKAction.sequence([
            SKAction.run {
                flip.run(SKAction.play())
            }
            ]))
    }
    
    func flipWithOutAnimation()
    {
        let firstHalfFlip = SKAction.scaleX(to: 0.0, duration: 0)
        let secondHalfFlip = SKAction.scaleX(to: 1.0, duration: 0)
        
        setScale(1.0)
        
        if faceUp {
            self.texture = self.backTexture
          }else {
            self.texture = self.frontTexture
          }
        faceUp = !faceUp
      }
    
    
    func flip() {
        let firstHalfFlip = SKAction.scaleX(to: 0.0, duration: 0.5)
      let secondHalfFlip = SKAction.scaleX(to: 1.0, duration: 0.5)
        let flip = SKAudioNode(fileNamed: "flipcard.mp3")

      setScale(1.0)
      
        flip.autoplayLooped = false
        self.addChild(flip)
        self.run(SKAction.sequence([
            SKAction.run {
                flip.run(SKAction.play())
            }
            ]))
        
      if faceUp {
        run(firstHalfFlip) {
          self.texture = self.backTexture
          
          self.run(secondHalfFlip)
        }
      } else {
        run(firstHalfFlip) {
          self.texture = self.frontTexture
          
          self.run(secondHalfFlip)
        }
      }
      faceUp = !faceUp
    }

    
    let cardType :CardType
    let cardSuit : CardSuit
    let cardBack :CardBack
    var cardNum = -1
    var cardSuitNum = -1
    var faceUp = false
    let frontTexture :SKTexture
    let backTexture :SKTexture
    let cardArray: [[String]] = [["jokerDefualt1", "heartAce", "heartTwo", "heartThree", "heartFour", "heartFive", "heartSix", "heartSeven", "heartEight", "heartNine", "heartTen", "heartJester", "heartQueen", "heartKing"],
                     
                     ["jokerDefualt1", "diamondAce", "diamondTwo", "diamondThree", "diamondFour", "diamondFive", "diamondSix", "diamondSeven", "diamondEight", "diamondNine", "diamondTen", "diamondJester", "diamondQueen", "diamondKing"],
                     
                     ["jokerDefualt1", "spadeAce", "spadeTwo", "spadeThree", "spadeFour", "spadeFive", "spadeSix", "spadeSeven", "spadeEight", "spadeNine", "spadeTen", "spadeJester", "spadeQueen", "spadeKing"],
                     
                     ["jokerDefualt1", "clubAce", "clubTwo", "clubThree", "clubFour", "clubFive", "clubSix", "clubSeven", "clubEight", "clubNine", "clubTen", "clubJester", "clubQueen", "clubKing"]]
  
    
    
  required init?(coder aDecoder: NSCoder) {
    fatalError("NSCoding not supported")
  }
  
    init(cardType: CardType, cardSuit: CardSuit, cardBack: CardBack) {
      self.cardType = cardType
      self.cardSuit = cardSuit
      self.cardBack = cardBack
    
        switch cardBack {
        case .black:
            backTexture = SKTexture(imageNamed: "cardBackBlack")
        case .white:
            backTexture = SKTexture(imageNamed: "cardBackWhite")
        case .blue:
            backTexture = SKTexture(imageNamed: "cardBackBlue")
        case .green:
            backTexture = SKTexture(imageNamed: "cardBackGreen")
        case .red:
            backTexture = SKTexture(imageNamed: "cardBackRed")
        case .gold:
            backTexture = SKTexture(imageNamed: "cardBackGold")
        }
        
        
    switch cardType {
    case . joker:
        cardNum = 0
    case .ace:
        cardNum = 1
    case .king:
        cardNum = 13
    case .queen:
        cardNum = 12
    case .jester:
        cardNum = 11
    case .ten:
        cardNum = 10
    case .nine:
        cardNum = 9
    case .eight:
        cardNum = 8
    case .seven:
        cardNum = 7
    case .six:
        cardNum = 6
    case .five:
        cardNum = 5
    case .four:
        cardNum = 4
    case .three:
        cardNum = 3
    case .two:
        cardNum = 2
    }
        
    switch cardSuit {
    case .heart:
        cardSuitNum = 0
    case .diamond:
        cardSuitNum = 1
    case .spade:
        cardSuitNum = 2
    case .club:
        cardSuitNum = 3
    }
        
        
        
        
    var card = cardArray[cardSuitNum][cardNum] // Getting card value based of numbers changed through the cases
    frontTexture = SKTexture(imageNamed: card) // Setting Card Value
    
        super.init(texture: backTexture, color: .clear, size: backTexture.size())
  }
}

