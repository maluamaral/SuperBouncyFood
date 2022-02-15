//
//  Background.swift
//  SuperBouncyFood
//
//  Created by Felipe Seolin Bento on 14/02/22.
//

import SpriteKit

class Background {
    private var node: SKNode
    private var background: SKSpriteNode!
    private var backgroundReverse: SKSpriteNode!
    
    private var camera: SKCameraNode
    private var gameArea: SKSpriteNode
    
    private var isShowingPrimaryBackground = true
    
    init(node: SKNode, gameArea: SKSpriteNode, camera: SKCameraNode) {
        self.node = node
        self.gameArea = gameArea
        self.camera = camera
        
        start()
    }
    
    func start() {
        background = node.childNode(withName: "background") as? SKSpriteNode
        backgroundReverse = node.childNode(withName: "backgroundReverse") as? SKSpriteNode
        // update position
        background.position.y = camera.position.y
        backgroundReverse.position.y = background.frame.maxY + background.frame.midY
        isShowingPrimaryBackground = true
    }
    
    func update() {
        if isShowingPrimaryBackground && background.frame.maxY < camera.position.y - (gameArea.frame.height / 2) {
            background.position.y = backgroundReverse.frame.maxY
            isShowingPrimaryBackground = false
        } else if !isShowingPrimaryBackground && backgroundReverse.frame.maxY < camera.position.y - (gameArea.frame.height / 2) {
            backgroundReverse.position.y = background.frame.maxY
            isShowingPrimaryBackground = true
        }
    }
    
}

