//
//  Background.swift
//  SuperBouncyFood
//
//  Created by Felipe Seolin Bento on 14/02/22.
//

import SpriteKit

class Background {
    private var gameScene: GameScene
    private var background: SKSpriteNode!
    private var backgroundReverse: SKSpriteNode!
    
    private var camera: SKCameraNode
    private var gameArea: SKSpriteNode
    
    private var isShowingPrimaryBackground = true
    
    init(gameScene: GameScene, gameArea: SKSpriteNode, camera: SKCameraNode) {
        self.gameScene = gameScene
        self.gameArea = gameArea
        self.camera = camera
        
        start()
    }
    
    func start() {
        background = gameScene.childNode(withName: "background") as? SKSpriteNode
        backgroundReverse = gameScene.childNode(withName: "backgroundReverse") as? SKSpriteNode
        // update position
        background.position.y = camera.position.y
        backgroundReverse.position.y = background.frame.maxY + background.frame.midY
        isShowingPrimaryBackground = true
    }
    
    func update() {
        if isShowingPrimaryBackground && background.frame.maxY < camera.position.y - (gameArea.frame.height / 2) {
            background.position.y = backgroundReverse.position.y + backgroundReverse.frame.height
            isShowingPrimaryBackground = false
        } else if !isShowingPrimaryBackground && backgroundReverse.frame.maxY < camera.position.y - (gameArea.frame.height / 2) {
            backgroundReverse.position.y = background.position.y + background.frame.height
            isShowingPrimaryBackground = true
        }
    }
}

