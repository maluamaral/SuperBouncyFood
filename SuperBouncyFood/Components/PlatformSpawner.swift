//
//  PlataformSpawner.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 01/02/22.
//

import SpriteKit

class PlatformSpawner {
    
    private var platformModel: SKSpriteNode
    private var parent: SKNode
    private var platforms = [SKSpriteNode]()
    private var pointMarkers = [SKSpriteNode]()
    private var player: Player
    private var gameArea: SKSpriteNode!
    
    private var jump : CGFloat = 0
    private var reachLimit: Bool = false
    
    
    init(platformModel: SKSpriteNode, parent: SKNode, player: Player, gameArea: SKSpriteNode) {
        self.platformModel = platformModel
        self.parent = parent
        self.player = player
        self.gameArea = gameArea
        
    }
    
    func start() {
        makePlatforms()
    }
    
    func makePlatforms() {
        let frameSize: CGFloat = gameArea.frame.size.height
        let spaceBetweenPlatforms: CGFloat = platformModel.size.height * 3

        for _ in 0...Int(frameSize / spaceBetweenPlatforms) {
            spawnPlatform()
        }
    }
    
    func spawnPlatform() {
        let spaceBetweenPlatforms: CGFloat = platformModel.size.height * 3
        var y: CGFloat = 370
        var isRight = true
        if let lastPlatform = platforms.last {
            y = lastPlatform.frame.maxY + spaceBetweenPlatforms
            isRight = lastPlatform.position.x < gameArea.frame.midX
        }
        
        let minLeft: CGFloat = gameArea.frame.minX + (platformModel.size.width / 3)
        let maxRight: CGFloat = gameArea.frame.maxX - (platformModel.size.width / 4)
        let midLeft: CGFloat = gameArea.frame.midX - (platformModel.size.width / 2)
        let midRight: CGFloat = gameArea.frame.midX + (platformModel.size.width / 2)
        
        let x: CGFloat = isRight ?
            CGFloat.random(in: midRight...maxRight) :
            CGFloat.random(in: minLeft...midLeft)
        let spawnPoint = CGPoint(x: x, y: y)
        spawn(at: spawnPoint)
    }
    
    func update(ground: SKNode, dish: SKNode, base: SKSpriteNode) {
        guard let playerVelocity = player.node.physicsBody?.velocity else {
            return
        }
        
        // Check if reached limit
        let limit: CGFloat = gameArea.frame.size.height * 0.40
        if player.node.position.y >= limit {
            reachLimit = true
        }
        // If has not reach the limit or the player is not falling, return
        if !reachLimit {
            return
        }
        
        let distance: CGFloat = abs(playerVelocity.dy / 50)
        for platform in platforms {
            platform.position.y -= distance
            if platform.frame.maxY < gameArea.frame.minY {
                platforms.removeFirst()
                platform.removeFromParent()
                updatePlatforms()
            }
        }
        
        ground.position.y -= CGFloat(distance)
        dish.position.y -= CGFloat(distance)
        base.position.y -= CGFloat(distance)
        
        if !player.isMoving {
            reachLimit = false
        }
        
        updateGround(distance: distance, ground: ground, dish: dish, base: base)
    }
    
    func updateGround(distance: CGFloat, ground: SKNode, dish: SKNode, base: SKSpriteNode) {
        if ground.parent == nil && dish.parent == nil && base.parent == nil {
            return
        }
        // Update position
        if ground.parent != nil {
            ground.position.y -= CGFloat(distance)
        }
        if dish.parent != nil {
            dish.position.y -= CGFloat(distance)
        }
        if base.parent != nil {
            base.position.y -= CGFloat(distance)
        }
        // Remove from parent if under screen
        if ground.parent != nil && ground.frame.maxY < gameArea.frame.minY {
            ground.removeFromParent()
        }
        if dish.parent != nil && dish.frame.maxY < gameArea.frame.minY {
            dish.removeFromParent()
        }
        if base.parent != nil && base.frame.maxY < gameArea.frame.minY {
            GameScene.score = 2
            base.removeFromParent()
        }
    }
    
    func updatePlatforms() {
        spawnPlatform()
        GameScene.score += 2
    }
    
    func spawn(at position: CGPoint) {
        let new = platformModel.copy() as! SKSpriteNode
        new.position = position
       
        new.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 242, height: 45))
        new.physicsBody?.isDynamic = false
        new.physicsBody?.affectedByGravity = false
        new.name = "platform"
        
        // case is left
        if new.position.x >= gameArea.frame.midX {
            new.xScale = -(new.xScale)
        }
        parent.addChild(new)
        platforms.append(new)
        
    }
    
}
