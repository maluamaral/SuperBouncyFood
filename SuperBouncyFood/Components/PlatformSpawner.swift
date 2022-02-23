//
//  PlataformSpawner.swift
//  SuperBouncyFood
//
//  Created by Maria Luiza Amaral on 01/02/22.
//

import SpriteKit

class PlatformSpawner {
    
    private var parent: GameScene
    
    private var platforms = [SKSpriteNode]()
    private var platformModel: SKSpriteNode
    
    private var player: Player
    private var gameArea: SKSpriteNode
    private var camera: SKCameraNode
    private var ground: Ground
    
    init(platformModel: SKSpriteNode, parent: GameScene, player: Player, gameArea: SKSpriteNode, camera: SKCameraNode, ground: Ground) {
        self.platformModel = platformModel
        self.parent = parent
        self.player = player
        self.gameArea = gameArea
        self.camera = camera
        self.ground = ground
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
        
        parent.viewController.firstPlatformPosition = platforms.first
    }
    
    func spawnPlatform() {
        let spaceBetweenPlatforms: CGFloat = platformModel.size.height * 3
        var y: CGFloat = ground.node.frame.maxY + spaceBetweenPlatforms
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
    
    func update(dish: SKNode, base: SKSpriteNode) {
        updateGround(dish: dish, base: base)
        updatePlatforms()
        
        parent.viewController.firstPlatformPosition = platforms.first
    }
    
    func updateGround(dish: SKNode, base: SKSpriteNode) {
        if ground.node.parent == nil && dish.parent == nil && base.parent == nil {
            return
        }
        // Check if ground, dish, and base is off screen
        if ground.node.frame.maxY < camera.position.y - (gameArea.frame.height / 2) {
            ground.node.removeFromParent()
            dish.removeFromParent()
            base.removeFromParent()
        }
    }
    
    // Check if some platform is off screen
    func updatePlatforms() {
        for (i, platform) in platforms.enumerated() {
            if parent.isOffCamera(yPosition: platform.frame.maxY) {
                platform.removeFromParent()
                platforms.remove(at: i)
                spawnPlatform()
            }
        }
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
