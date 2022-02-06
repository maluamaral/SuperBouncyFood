//
//  GameOverScene.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 05/02/22.
//
import SpriteKit
import SwiftUI

class GameOverScene: SKScene {
    private var buttonTryAgain: SKSpriteNode!
    private var score: SKLabelNode!
    var finalScore: Int = 0

    
    override func didMove(to view: SKView) {
        
        buttonTryAgain = childNode(withName: "tryAgain") as? SKSpriteNode
        
        score = childNode(withName: "score") as? SKLabelNode
        
        showFinalScore()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
           let location = touch.location(in: self)
            
            if buttonTryAgain.contains(location) {
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene?.scaleMode = .aspectFill
                view?.presentScene(gameScene)
            }
        }
    }
    
     func showFinalScore(){
        score.text = "\(finalScore)m"
    }
}
