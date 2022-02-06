//
//  HomeScene.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 05/02/22.
//

import SpriteKit

class HomeScene: SKScene {
    private var button: SKSpriteNode!
    
    
    override func didMove(to view: SKView) {
        button = childNode(withName: "button") as? SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if button.contains(location) {
                let gameScene = GameScene(fileNamed: "GameScene")
                gameScene?.scaleMode = .aspectFill
                view?.presentScene(gameScene)
            }
        }
    }
    
}

